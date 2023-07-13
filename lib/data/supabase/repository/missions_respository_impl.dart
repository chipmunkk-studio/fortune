import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/core/util/logger.dart';
import 'package:foresh_flutter/data/supabase/request/request_mission_reward_update.dart';
import 'package:foresh_flutter/data/supabase/service/mission/mission_reward_service.dart';
import 'package:foresh_flutter/data/supabase/service/mission/missions_service.dart';
import 'package:foresh_flutter/data/supabase/service/mission/mission_clear_conditions_service.dart';
import 'package:foresh_flutter/data/supabase/service/mission/mission_clear_user_service.dart';
import 'package:foresh_flutter/data/supabase/service/user_service.dart';
import 'package:foresh_flutter/domain/supabase/entity/mission/missions_entity.dart';
import 'package:foresh_flutter/domain/supabase/entity/mission/mission_clear_condition_entity.dart';
import 'package:foresh_flutter/domain/supabase/repository/mission_respository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MissionsRepositoryImpl extends MissionsRepository {
  final MissionsService missionNormalService;
  final UserService userService;
  final MissionClearUserService missionClearUserService;
  final MissionRewardService missionRewardService;
  final MissionsClearConditionsService missionClearConditionsService;

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
      final user = await userService.findUserByPhoneNonNull(Supabase.instance.client.auth.currentUser?.phone);
      final result = await missionNormalService.findAllMissions(isGlobal: user.isGlobal);
      return result;
    } on FortuneFailure catch (e) {
      FortuneLogger.error('errorCode: ${e.code}, errorMessage: ${e.message}');
      rethrow;
    }
  }

  @override
  Future<List<MissionClearConditionEntity>> getMissionClearConditions(int missionId) async {
    try {
      final result = await missionClearConditionsService.findMissionClearConditionByMissionId(missionId);
      if (result.isEmpty) {
        throw CommonFailure(errorMessage: '현재 미션 카드를 불러 올 수 없습니다');
      }
      return result;
    } on FortuneFailure catch (e) {
      FortuneLogger.error('errorCode: ${e.code}, errorMessage: ${e.message}');
      rethrow;
    }
  }

  @override
  Future<void> postMissionClear({
    required int missionId,
    required String email,
  }) async {
    try {
      final mission = await missionNormalService.findMissionById(missionId);
      final user = await userService.findUserByPhoneNonNull(Supabase.instance.client.auth.currentUser?.phone);

      // 리워드가 모두 소진 되었을 경우.
      if (mission.missionReward.remainCount == 0) {
        throw CommonFailure(errorMessage: "리워드가 모두 소진 되었습니다.");
      }

      // 미션 리워드 상태 업데이트.
      await missionRewardService.update(
        missionId,
        request: RequestMissionRewardUpdate(
          remainCount: mission.missionReward.remainCount - 1,
        ),
      );

      // 미션 클리어 사용자 추가.
      await missionClearUserService.insert(
        email: email,
        missionId: mission.id,
        userId: user.id,
      );
    } on FortuneFailure catch (e) {
      FortuneLogger.error('errorCode: ${e.code}, errorMessage: ${e.message}');
      rethrow;
    }
  }

  @override
  Future<MissionsEntity> getMissionById(int missionId) async {
    try {
      final result = await missionNormalService.findMissionById(missionId);
      return result;
    } on FortuneFailure catch (e) {
      FortuneLogger.error('errorCode: ${e.code}, errorMessage: ${e.message}');
      rethrow;
    }
  }

  @override
  Future<MissionsEntity> getMissionByMarkerId(int markerId) async {
    try {
      final result = await missionNormalService.findMissionByMarkerId(markerId);
      return result;
    } on FortuneFailure catch (e) {
      FortuneLogger.error('errorCode: ${e.code}, errorMessage: ${e.message}');
      rethrow;
    }
  }
}
