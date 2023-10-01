import 'package:fortune/core/error/failure/custom_failure.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/data/supabase/request/request_mission_clear_user.dart';
import 'package:fortune/data/supabase/request/request_mission_reward_update.dart';
import 'package:fortune/data/supabase/service/mission/mission_clear_conditions_service.dart';
import 'package:fortune/data/supabase/service/mission/mission_clear_user_service.dart';
import 'package:fortune/data/supabase/service/mission/mission_reward_service.dart';
import 'package:fortune/data/supabase/service/mission/missions_service.dart';
import 'package:fortune/domain/supabase/entity/mission/mission_clear_condition_entity.dart';
import 'package:fortune/domain/supabase/entity/mission/mission_reward_entity.dart';
import 'package:fortune/domain/supabase/entity/mission/missions_entity.dart';
import 'package:fortune/domain/supabase/repository/mission_respository.dart';

class MissionsRepositoryImpl extends MissionsRepository {
  final MissionsService missionNormalService;
  final MissionClearUserService missionClearUserService;
  final MissionRewardService missionRewardService;
  final MissionsClearConditionsService missionClearConditionsService;

  MissionsRepositoryImpl({
    required this.missionNormalService,
    required this.missionClearConditionsService,
    required this.missionClearUserService,
    required this.missionRewardService,
  });

  @override
  Future<List<MissionsEntity>> getAllMissions() async {
    try {
      final result = await missionNormalService.findAllMissions();
      return result;
    } on FortuneFailure catch (e) {
      throw e.handleFortuneFailure(
        description: '미션 불러오기 실패',
      );
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
      throw e.handleFortuneFailure(
        description: '미션 클리어 조건 불러오기 실패',
      );
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
      if (mission.missionReward.remainCount == 0) {
        throw const CustomFailure(errorDescription: "리워드가 모두 소진 되었습니다.");
      }

      // 미션 리워드 상태 업데이트.
      await missionRewardService.update(
        mission.missionReward.id,
        request: RequestMissionRewardUpdate(
          remainCount: mission.missionReward.remainCount - 1,
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
      throw e.handleFortuneFailure(
        description: '미션 클리어 실패',
      );
    }
  }

  @override
  Future<MissionsEntity> getMissionById(int missionId) async {
    try {
      final result = await missionNormalService.findMissionById(missionId);
      return result;
    } on FortuneFailure catch (e) {
      throw e.handleFortuneFailure(
        description: '미션 불러오기 실패',
      );
    }
  }

  @override
  Future<MissionsEntity> getMissionByMarkerId(int markerId) async {
    try {
      final result = await missionNormalService.findMissionByMarkerId(markerId);
      return result;
    } on FortuneFailure catch (e) {
      throw e.handleFortuneFailure(
        description: '미션 불러오기 실패',
      );
    }
  }

  @override
  Future<MissionsEntity?> getMissionOrNullByMarkerId(int markerId) async {
    try {
      final result = await missionNormalService.findMissionOrNullByMarkerId(markerId);
      return result;
    } on FortuneFailure catch (e) {
      throw e.handleFortuneFailure(
        description: '미션 불러오기 실패',
      );
    }
  }

  @override
  Future<MissionClearConditionEntity?> getMissionClearConditionsOrNullByMarkerId(int markerId) async {
    try {
      final result = await missionClearConditionsService.findMissionClearConditionOrNullByMarkerId(markerId);
      return result;
    } on FortuneFailure catch (e) {
      throw e.handleFortuneFailure(
        description: '미션 불러오기 실패',
      );
    }
  }

  @override
  Future<MissionRewardEntity> getMissionRewardById(int markerId) async {
    try {
      final result = await missionRewardService.findMissionRewardNullableById(markerId) ?? MissionRewardEntity.empty();
      return result;
    } on FortuneFailure catch (e) {
      throw e.handleFortuneFailure(
        description: '미션보상 불러오기 실패',
      );
    }
  }
}
