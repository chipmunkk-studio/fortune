

import 'package:foresh_flutter/domain/supabase/entity/mission/mission_clear_condition_entity.dart';
import 'package:foresh_flutter/domain/supabase/entity/mission/missions_entity.dart';

abstract class MissionsRepository {
  // 미션 목록 불러오기.
  Future<List<MissionsEntity>> getAllMissions();

  // 미션 상세 조건.
  Future<List<MissionClearConditionEntity>> getMissionClearConditions(int missionId);

  // 미션 클리어 요청.
  Future<void> postMissionClear({
    required int missionId,
    required String email,
  });

  // 미션 아이디로 조회.
  Future<MissionsEntity> getMissionById(int missionId);

  // 마커 아이디로 조회.
  Future<MissionsEntity> getMissionByMarkerId(int markerId);
}