import 'package:fortune/core/error/failure/custom_failure.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/data/supabase/request/request_mission_clear_user.dart';
import 'package:fortune/data/supabase/request/request_mission_reward_update.dart';
import 'package:fortune/data/supabase/service/mission/mission_clear_conditions_service.dart';
import 'package:fortune/data/supabase/service/mission/mission_clear_user_histories_service.dart';
import 'package:fortune/data/supabase/service/mission/mission_reward_service.dart';
import 'package:fortune/data/supabase/service/mission/missions_service.dart';
import 'package:fortune/data/supabase/service/user_service.dart';
import 'package:fortune/domain/supabase/entity/mission/mission_clear_condition_entity.dart';
import 'package:fortune/domain/supabase/entity/mission/mission_clear_user_count_entity.dart';
import 'package:fortune/domain/supabase/entity/mission/mission_clear_user_histories_entity.dart';
import 'package:fortune/domain/supabase/entity/mission/missions_entity.dart';
import 'package:fortune/domain/supabase/repository/mission_respository.dart';

class MissionsRepositoryImpl extends MissionsRepository {
  final MissionsService missionNormalService;
  final MissionClearUserHistoriesService missionClearUserService;
  final MissionRewardService missionRewardService;
  final MissionsClearConditionsService missionClearConditionsService;

  final FortuneUserService userService;

  MissionsRepositoryImpl({
    required this.missionNormalService,
    required this.missionClearConditionsService,
    required this.missionClearUserService,
    required this.missionRewardService,
    required this.userService,
  });

  @override
  Future<List<MissionsEntity>> getAllMissions() async {
    try {
      final result = await missionNormalService.findAllMissions();
      return result;
    } on FortuneFailure catch (e) {
      throw e.handleFortuneFailure();
    }
  }

  @override
  Future<List<MissionClearConditionEntity>> getMissionClearConditionsByMissionId(int missionId) async {
    try {
      final result = await missionClearConditionsService.findMissionClearConditionByMissionId(missionId);
      if (result.isEmpty) {
        throw CustomFailure(errorDescription: FortuneTr.msgUnableToLoadMissionCard);
      }
      return result;
    } on FortuneFailure catch (e) {
      throw e.handleFortuneFailure();
    }
  }

  @override
  Future<void> postMissionClear({
    required int missionId,
    required int userId,
  }) async {
    try {
      final mission = await missionNormalService.findMissionById(missionId);

      // 리워드가 모두 소진 되었을 경우.
      if (mission.reward.remainCount == 0) {
        throw CustomFailure(errorDescription: FortuneTr.msgRewardExhausted);
      }

      // 미션 리워드 상태 업데이트.
      await missionRewardService.update(
        mission.reward.id,
        request: RequestMissionRewardUpdate(
          remainCount: mission.reward.remainCount - 1,
        ),
      );

      // 미션 클리어 사용자 추가.
      await missionClearUserService.insert(
        RequestMissionClearUser.insert(
          mission: mission.id,
          user: userId,
        ),
      );
    } on FortuneFailure catch (e) {
      throw e.handleFortuneFailure();
    }
  }

  @override
  Future<MissionsEntity> getMissionById(int missionId) async {
    try {
      final result = await missionNormalService.findMissionById(missionId);
      return result;
    } on FortuneFailure catch (e) {
      throw e.handleFortuneFailure(description: FortuneTr.msgInvalidMission);
    }
  }

  @override
  Future<MissionClearConditionEntity?> getMissionClearConditionsOrNullByMarkerId(int markerId) async {
    try {
      final result = await missionClearConditionsService.findMissionClearConditionOrNullByMarkerId(markerId);
      return result;
    } on FortuneFailure catch (e) {
      throw e.handleFortuneFailure();
    }
  }

  @override
  Future<List<MissionClearUserHistoriesEntity>> getMissionClearUsers({
    int start = 0,
    int end = 20,
  }) async {
    try {
      final result = await missionClearUserService.findAllMissionClearUsers(
        start: start,
        end: end,
      );
      return result;
    } on FortuneFailure catch (e) {
      throw e.handleFortuneFailure();
    }
  }

  @override
  Future<List<MissionClearUserHistoriesEntity>> getMissionClearUsersByUserId(int userId) async {
    try {
      final result = await missionClearUserService.findAllMissionClearUserByUserId(userId);
      return result;
    } on FortuneFailure catch (e) {
      throw e.handleFortuneFailure();
    }
  }

  @override
  Future<List<MissionClearUserCountEntity>> getMissionClearUsersByRanking() async {
    try {
      final countMap = await missionClearUserService.findAllMissionClearCountsByRanking();
      final List<MissionClearUserCountEntity> rankingList = [];
      for (var email in countMap.keys) {
        final user = await userService.findUserByEmail(email, columnsToSelect: []); // 이메일로 사용자 조회
        if (user != null) {
          rankingList.add(MissionClearUserCountEntity(user: user, clearCount: countMap[email]!));
        }
      }
      // 미션 클리어 횟수에 따라 정렬
      rankingList.sort((a, b) => b.clearCount.compareTo(a.clearCount));

      // 지정된 범위의 랭킹만 반환
      return rankingList;
    } on FortuneFailure catch (e) {
      throw e.handleFortuneFailure();
    }
  }
}
