import 'package:dartz/dartz.dart';
import 'package:fortune/core/error/failure/common_failure.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/core/util/usecase.dart';
import 'package:fortune/data/supabase/request/request_alarm_feeds.dart';
import 'package:fortune/data/supabase/request/request_obtain_history.dart';
import 'package:fortune/data/supabase/response/fortune_user_response.dart';
import 'package:fortune/data/supabase/response/obtain_history_response.dart';
import 'package:fortune/data/supabase/service_ext.dart';
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

class ObtainMarkerMainUseCase implements UseCase1<MarkerObtainEntity, RequestObtainMarkerParam> {
  final MarkerRepository markerRepository;
  final UserRepository userRepository;
  final AlarmFeedsRepository alarmFeedsRepository;
  final AlarmRewardRepository rewardRepository;
  final ObtainHistoryRepository obtainHistoryRepository;
  final MissionsRepository missionsRepository;
  final IngredientRepository ingredientRepository;

  ObtainMarkerMainUseCase({
    required this.markerRepository,
    required this.userRepository,
    required this.alarmFeedsRepository,
    required this.obtainHistoryRepository,
    required this.missionsRepository,
    required this.rewardRepository,
    required this.ingredientRepository,
  });

  @override
  Future<FortuneResult<MarkerObtainEntity>> call(RequestObtainMarkerParam param) async {
    try {
      final marker = param.marker;
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

      // 마커 재배치.
      await markerRepository.reLocateMarker(
        userId: currentUser.id,
        location: marker.location,
        ingredient: marker.ingredient,
        markerId: marker.id,
      );

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
            krIngredientName: marker.ingredient.krName,
            enIngredientName: marker.ingredient.enName,
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
      final histories = await obtainHistoryRepository.getHistoriesByUser(
        currentUser.id,
        columnsToSelect: [
          ObtainHistoryColumn.id,
        ],
      );

      return Right(
        MarkerObtainEntity(
          user: currentUser,
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
      final isClear = markerEntity.hitCount == clearConditions.relayCount && markerEntity.lastObtainUser == user.id;
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
        await alarmFeedsRepository.insertAlarm(
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
}
