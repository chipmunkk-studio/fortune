import 'package:dartz/dartz.dart';
import 'package:fortune/core/error/failure/common_failure.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/core/util/usecase.dart';
import 'package:fortune/data/supabase/request/request_alarm_feeds.dart';
import 'package:fortune/data/supabase/request/request_fortune_user.dart';
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
      final prevUser = await userRepository.findUserByPhoneNonNull();
      final marker = await markerRepository.findMarkerById(param.marker.id);

      // 유저의 티켓이 없고, 리워드 티켓이 감소 일 경우.
      final currentTicket = prevUser.ticket;
      final requiredTicket = marker.ingredient.rewardTicket.abs();

      if (currentTicket < requiredTicket && marker.ingredient.type != IngredientType.coin) {
        throw CommonFailure(errorMessage: FortuneTr.requireMoreTicket((requiredTicket - currentTicket).toString()));
      }

      // 마커 재배치.
      await markerRepository.reLocateMarker(
        marker: marker,
        user: prevUser,
        location: param.marker.location,
      );

      int updatedTicket = prevUser.ticket;
      int markerObtainCount = prevUser.markerObtainCount;

      // 티켓 및 획득 카운트 업데이트.
      updatedTicket = prevUser.ticket + ingredient.rewardTicket;
      markerObtainCount =
          param.marker.ingredient.type != IngredientType.coin ? markerObtainCount + 1 : markerObtainCount;

      // 사용자 티켓 정보 업데이트.
      final updateUser = await userRepository.updateUserTicket(
        ticket: updatedTicket < 0 ? 0 : updatedTicket,
        markerObtainCount: markerObtainCount,
      );

      // 다이얼로그 타이틀.
      final dialogHeadings = () {
        if (prevUser.grade.name != updateUser.grade.name) {
          return "등급 업을 축하합니다!!";
        } else if (prevUser.level != updateUser.level) {
          return "레벨 업을 축하합니다";
        } else {
          return '';
        }
      }();

      // 다이얼로그 내용.
      final dialogContent = () {
        if (prevUser.grade.name != updateUser.grade.name) {
          return "${prevUser.grade.name} > ${updateUser.grade.name}";
        } else if (prevUser.level != updateUser.level) {
          return "${prevUser.level} > ${updateUser.level}";
        } else {
          return '';
        }
      }();

      // 레벨업 혹은 등급 업을 했을 경우.
      if (prevUser.level != updateUser.level) {
        await _generateRewardHistory(prevUser);
      }

      // 히스토리 추가.
      if (marker.ingredient.type != IngredientType.coin) {
        await obtainHistoryRepository
            .insertObtainHistory(
          request: RequestObtainHistory.insert(
            userId: prevUser.id,
            markerId: marker.id,
            ingredientId: marker.ingredient.id,
            nickName: prevUser.nickname,
            locationName: param.kLocation,
            ingredientName: param.marker.ingredient.name,
          ),
        )
            .then(
          (value) async {
            await _confirmRelayMissionClear(
              user: prevUser,
              markerId: marker.id,
            );
          },
        );
      }

      // 히스토리 수.
      final histories = await obtainHistoryRepository.getHistoriesByUser(userId: prevUser.id);

      return Right(
        MarkerObtainEntity(
          user: updateUser,
          dialogContent: dialogContent,
          dialogHeadings: dialogHeadings,
          isLevelOrGradeUp: dialogContent.isNotEmpty && dialogHeadings.isNotEmpty,
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
        final ingredient = await ingredientRepository.getIngredientByRandom(rewardType);

        // 마커 획득 히스토리 추가.
        await obtainHistoryRepository.insertObtainHistory(
          request: RequestObtainHistory.insert(
            ingredientId: ingredient.id,
            userId: user.id,
            nickName: user.nickname,
            ingredientName: ingredient.name,
            isReward: true,
          ),
        );

        // 알람 히스토리 추가.
        final response = await rewardRepository.insertRewardHistory(
          user: user,
          alarmRewardInfo: rewardType,
          ingredient: ingredient,
        );

        await eventNoticesRepository.insertAlarm(
          RequestAlarmFeeds.insert(
            headings: '릴레이 미션을 클리어 하셨습니다.',
            content: '릴레이 미션 클리어!!',
            type: AlarmFeedType.user.name,
            users: user.id,
            alarmRewardHistory: response.id,
          ),
        );

        await missionsRepository.postMissionClear(
          missionId: clearConditions.mission.id,
          userId: user.id,
        );
      }
    }
  }

  _generateRewardHistory(FortuneUserEntity user) async {
    final rewardType = await rewardRepository.findRewardInfoByType(AlarmRewardType.level);
    final ingredient = await ingredientRepository.getIngredientByRandom(rewardType);

    final response = await rewardRepository.insertRewardHistory(
      user: user,
      alarmRewardInfo: rewardType,
      ingredient: ingredient,
    );

    await eventNoticesRepository.insertAlarm(
      RequestAlarmFeeds.insert(
        type: AlarmFeedType.user.name,
        headings: '레벨 업을 축하합니다!',
        content: '레벨업 축하!',
        users: user.id,
        alarmRewardHistory: response.id,
      ),
    );
  }
}
