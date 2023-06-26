import 'package:foresh_flutter/domain/supabase/entity/normal_mission_clear_condition_entity.dart';
import 'package:foresh_flutter/domain/supabase/entity/normal_mission_entity.dart';

abstract class MissionNormalRepository {
  // 미션 목록 불러오기.
  Future<List<MissionNormalEntity>> getAllMissions(bool isGlobal);

  // 미션 상세 조건.
  Future<List<MissionNormalClearConditionEntity>> getMissionClearConditions(int missionId);

  // 미션 클리어 요청.
  Future<void> postMissionClear({
    required int missionId,
    required String email,
  });

  // 미션 아이디로 조회.
  Future<MissionNormalEntity> getMissionById(int missionId);

  // 마커 아이디로 조회.
  Future<MissionNormalEntity> getMissionByMarkerId(int markerId);
}
