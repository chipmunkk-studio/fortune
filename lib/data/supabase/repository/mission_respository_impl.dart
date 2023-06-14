import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/core/util/logger.dart';
import 'package:foresh_flutter/data/supabase/service/mission_clear_conditions_service.dart';
import 'package:foresh_flutter/data/supabase/service/mission_clear_history_service.dart';
import 'package:foresh_flutter/data/supabase/service/mission_clear_user_service.dart';
import 'package:foresh_flutter/data/supabase/service/mission_service.dart';
import 'package:foresh_flutter/data/supabase/service/user_service.dart';
import 'package:foresh_flutter/domain/supabase/entity/mission_clear_condition_entity.dart';
import 'package:foresh_flutter/domain/supabase/entity/mission_entity.dart';
import 'package:foresh_flutter/domain/supabase/repository/mission_respository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MissionRepositoryImpl extends MissionRepository {
  final MissionService missionService;
  final UserService userService;
  final MissionClearUserService missionClearUserService;
  final MissionClearHistoryService missionClearHistoryService;
  final MissionClearConditionsService missionClearConditionsService;

  MissionRepositoryImpl({
    required this.missionService,
    required this.missionClearConditionsService,
    required this.missionClearHistoryService,
    required this.missionClearUserService,
    required this.userService,
  });

  @override
  Future<List<MissionEntity>> getAllMissions() async {
    try {
      final result = await missionService.findAllMissions();
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
      final mission = await missionService.findMissionById(missionId);
      final user = await userService.findUserByPhone(Supabase.instance.client.auth.currentUser?.phone);

      if (mission == null || user == null) {
        throw CommonFailure(errorMessage: "사용자 혹은 미션이 존재 하지 않습니다.");
      }
      if (mission.remainCount == 0) {
        throw CommonFailure(errorMessage: "리워드가 모두 소진 되었습니다.");
      }

      // 미션 상태 업데이트.
      final missionUpdate = missionService.update(
        missionId,
        remainCount: mission.rewardCount - 1,
      );

      // 미션 클리어 사용자 추가.
      final clearUser = await missionClearUserService.insert(
        email: email,
        missionId: mission.id,
        userId: user.id,
      );

      // 클리어 히스토리 추가.
      final clearHistory = await missionClearHistoryService.insert(
        userId: user.id,
        title: mission.title,
        subtitle: mission.subtitle,
        rewardImage: mission.rewardImage,
      );
    } on FortuneFailure catch (e) {
      FortuneLogger.error('errorCode: ${e.code}, errorMessage: ${e.message}');
      rethrow;
    }
  }
}
