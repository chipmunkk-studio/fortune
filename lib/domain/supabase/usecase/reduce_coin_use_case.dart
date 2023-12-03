import 'package:dartz/dartz.dart';
import 'package:fortune/core/error/failure/common_failure.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/core/util/usecase.dart';
import 'package:fortune/data/supabase/request/request_alarm_feeds.dart';
import 'package:fortune/data/supabase/response/fortune_user_response.dart';
import 'package:fortune/data/supabase/service_ext.dart';
import 'package:fortune/domain/supabase/entity/fortune_user_entity.dart';
import 'package:fortune/domain/supabase/entity/ingredient_entity.dart';
import 'package:fortune/domain/supabase/repository/alarm_feeds_repository.dart';
import 'package:fortune/domain/supabase/repository/alarm_reward_repository.dart';
import 'package:fortune/domain/supabase/repository/ingredient_respository.dart';
import 'package:fortune/domain/supabase/repository/user_repository.dart';

class ReduceCoinUseCase implements UseCase1<FortuneUserEntity, IngredientEntity> {
  final UserRepository userRepository;
  final IngredientRepository ingredientRepository;
  final AlarmRewardRepository rewardRepository;
  final AlarmFeedsRepository alarmFeedsRepository;

  ReduceCoinUseCase({
    required this.userRepository,
    required this.ingredientRepository,
    required this.rewardRepository,
    required this.alarmFeedsRepository,
  });

  @override
  Future<FortuneResult<FortuneUserEntity>> call(IngredientEntity ingredient) async {
    try {
      /// 현재 유저 상태.
      final currentUser = await userRepository.findUserByEmailNonNull(
        columnsToSelect: [
          UserColumn.id,
          UserColumn.email,
          UserColumn.level,
          UserColumn.nickname,
          UserColumn.ticket,
          UserColumn.markerObtainCount,
        ],
      );

      // 유저의 티켓이 없고, 리워드 티켓이 감소 일 경우.
      final currentTicket = currentUser.ticket;
      final requiredTicket = ingredient.rewardTicket.abs();

      if (currentTicket < requiredTicket && ingredient.type != IngredientType.coin) {
        throw CommonFailure(errorMessage: FortuneTr.requireMoreTicket((requiredTicket - currentTicket).toString()));
      }

      int updatedTicket = currentUser.ticket;
      int markerObtainCount = currentUser.markerObtainCount;

      // 티켓 및 획득 카운트 업데이트.
      updatedTicket = currentUser.ticket + ingredient.rewardTicket;
      markerObtainCount = ingredient.type != IngredientType.coin ? markerObtainCount + 1 : markerObtainCount;

      /// 다음 유저 상태 > 사용자 티켓 정보 업데이트.
      final updateUser = await userRepository.updateUserTicket(
        currentUser.email,
        ticket: updatedTicket < 0 ? 0 : updatedTicket,
        markerObtainCount: markerObtainCount,
      );

      /// 레벨업 혹은 등급 업을 했을 경우.(코인 소모시점을 레벨 업 혹은 등급업 시점이라고 봄)
      if (currentUser.level != updateUser.level) {
        await _generateLevelOrGradeUpRewardHistory(
          updateUser: updateUser,
          currentUser: currentUser,
        );
      }

      return Right(updateUser);
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }

  _generateLevelOrGradeUpRewardHistory({
    required FortuneUserEntity updateUser,
    required FortuneUserEntity currentUser,
  }) async {
    final isGradeUp = currentUser.grade.name != updateUser.grade.name;
    // 리워드 정보 가져옴. (레벨업/등급업)
    final rewardInfo = await rewardRepository.findRewardInfoByType(
      isGradeUp ? AlarmRewardType.grade : AlarmRewardType.level,
    );

    // 리워드 정보에 따라 재료 생성.
    final ingredient = await ingredientRepository.generateIngredientByRewardInfoType(rewardInfo);

    // 보상 히스토리 등록.
    final response = await rewardRepository.insertRewardHistory(
      user: updateUser,
      alarmRewardInfo: rewardInfo,
      ingredient: ingredient,
    );

    // 알람 등록.
    await alarmFeedsRepository.insertAlarm(
      RequestAlarmFeeds.insert(
        type: AlarmFeedType.user.name,
        headings: isGradeUp ? FortuneTr.msgNewGradeReached : FortuneTr.msgLevelUpHeadings,
        content: isGradeUp
            ? FortuneTr.msgAchievedGrade(updateUser.grade.name)
            : FortuneTr.msgLevelUpContents(updateUser.level.toString()),
        users: updateUser.id,
        alarmRewardHistory: response.id,
      ),
    );
  }
}
