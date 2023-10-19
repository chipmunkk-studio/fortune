import 'package:dartz/dartz.dart';
import 'package:fortune/core/error/failure/common_failure.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/core/util/usecase.dart';
import 'package:fortune/data/supabase/request/request_alarm_feeds.dart';
import 'package:fortune/data/supabase/request/request_obtain_history.dart';
import 'package:fortune/data/supabase/service/service_ext.dart';
import 'package:fortune/domain/supabase/entity/fortune_user_entity.dart';
import 'package:fortune/domain/supabase/entity/marker_obtain_entity.dart';
import 'package:fortune/domain/supabase/repository/alarm_feeds_repository.dart';
import 'package:fortune/domain/supabase/repository/alarm_reward_repository.dart';
import 'package:fortune/domain/supabase/repository/ingredient_respository.dart';
import 'package:fortune/domain/supabase/repository/marker_respository.dart';
import 'package:fortune/domain/supabase/repository/mission_respository.dart';
import 'package:fortune/domain/supabase/repository/obtain_history_repository.dart';
import 'package:fortune/domain/supabase/repository/user_repository.dart';
import 'package:fortune/domain/supabase/request/request_obtain_marker_param.dart';

class ObtainMarkerUseCase implements UseCase1<MarkerObtainEntity, RequestObtainMarkerParam> {
  final MarkerRepository markerRepository;
  final UserRepository userRepository;
  final AlarmFeedsRepository eventNoticesRepository;
  final AlarmRewardRepository rewardRepository;
  final ObtainHistoryRepository obtainHistoryRepository;
  final MissionsRepository missionsRepository;
  final IngredientRepository ingredientRepository;

  ObtainMarkerUseCase({
    required this.markerRepository,
    required this.userRepository,
    required this.eventNoticesRepository,
    required this.obtainHistoryRepository,
    required this.missionsRepository,
    required this.rewardRepository,
    required this.ingredientRepository,
  });

  @override
  Future<FortuneResult<MarkerObtainEntity>> call(RequestObtainMarkerParam param) async {
    try {
      final ingredient = param.marker.ingredient;
      final currentUser = await userRepository.findUserByEmailNonNull();
      final marker = await markerRepository.findMarkerById(param.marker.id);

      // 유저의 티켓이 없고, 리워드 티켓이 감소 일 경우.
      final currentTicket = currentUser.ticket;
      final requiredTicket = marker.ingredient.rewardTicket.abs();

      if (currentTicket < requiredTicket && marker.ingredient.type != IngredientType.coin) {
        throw CommonFailure(errorMessage: FortuneTr.requireMoreTicket((requiredTicket - currentTicket).toString()));
      }

      // 마커 재배치.
      await markerRepository.reLocateMarker(
        marker: marker,
        user: currentUser,
        location: param.marker.location,
      );

      int updatedTicket = currentUser.ticket;
      int markerObtainCount = currentUser.markerObtainCount;

      // 티켓 및 획득 카운트 업데이트.
      updatedTicket = currentUser.ticket + ingredient.rewardTicket;
      markerObtainCount =
          param.marker.ingredient.type != IngredientType.coin ? markerObtainCount + 1 : markerObtainCount;

      // 사용자 티켓 정보 업데이트.
      final updateUser = await userRepository.updateUserTicket(
        ticket: updatedTicket < 0 ? 0 : updatedTicket,
        markerObtainCount: markerObtainCount,
      );

      // 레벨업 혹은 등급 업을 했을 경우.
      if (currentUser.level != updateUser.level) {
        await _generateLevelOrGradeUpRewardHistory(
          updateUser: updateUser,
          currentUser: currentUser,
        );
      }

      // 히스토리 추가.
      if (marker.ingredient.type != IngredientType.coin) {
        await obtainHistoryRepository
            .insertObtainHistory(
          request: RequestObtainHistory.insert(
            userId: currentUser.id,
            markerId: marker.id,
            ingredientId: marker.ingredient.id,
            nickName: currentUser.nickname,
            locationName: param.kLocation,
            krIngredientName: param.marker.ingredient.krName,
            enIngredientName: param.marker.ingredient.enName,
          ),
        )
            .then(
          (value) async {
            await _confirmRelayMissionClear(
              user: currentUser,
              markerId: marker.id,
            );
          },
        );
      }

      // 히스토리 수.
      final histories = await obtainHistoryRepository.getHistoriesByUser(userId: currentUser.id);

      return Right(
        MarkerObtainEntity(
          user: updateUser,
          haveCount: histories.length,
        ),
      );
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }

  _confirmRelayMissionClear({
    required FortuneUserEntity user,
    required int markerId,
  }) async {
    final clearConditions = await missionsRepository.getMissionClearConditionsOrNullByMarkerId(markerId);
    if (clearConditions != null) {
      // 마커 조회.
      final markerEntity = await markerRepository.findMarkerById(markerId);
      // 클리어 조건. (내가 클리어 한 건지)
      final isClear = markerEntity.hitCount == clearConditions.requireCount && markerEntity.lastObtainUser == user.id;
      if (isClear) {
        // 미션 클리어.
        final rewardType = await rewardRepository.findRewardInfoByType(AlarmRewardType.relay);
        final ingredient = await ingredientRepository.generateIngredientByRewardInfoType(rewardType);

        // 알람 히스토리 추가.
        final response = await rewardRepository.insertRewardHistory(
          user: user,
          alarmRewardInfo: rewardType,
          ingredient: ingredient,
        );

        // 알람에 추가.
        await eventNoticesRepository.insertAlarm(
          RequestAlarmFeeds.insert(
            headings: FortuneTr.msgRelayMissionHeadings,
            content: FortuneTr.msgRelayMissionContents,
            type: AlarmFeedType.user.name,
            users: user.id,
            alarmRewardHistory: response.id,
          ),
        );

        // 미션 클리어.
        await missionsRepository.postMissionClear(
          missionId: clearConditions.mission.id,
          userId: user.id,
        );
      }
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
    await eventNoticesRepository.insertAlarm(
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
