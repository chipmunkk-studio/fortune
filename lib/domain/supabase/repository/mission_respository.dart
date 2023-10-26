import 'package:fortune/domain/supabase/entity/mission/mission_clear_condition_entity.dart';
import 'package:fortune/domain/supabase/entity/mission/mission_clear_user_histories_entity.dart';
import 'package:fortune/domain/supabase/entity/mission/missions_entity.dart';

abstract class MissionsRepository {
  // 미션 목록 불러오기.
  Future<List<MissionsEntity>> getAllMissions();

  // 미션 클리어 상세 조건.(미션아이디)
  Future<List<MissionClearConditionEntity>> getMissionClearConditionsByMissionId(int missionId);

  // 미션 클리어 상세 조건.(마커)
  Future<MissionClearConditionEntity?> getMissionClearConditionsOrNullByMarkerId(int markerId);

  // 미션 클리어 요청.
  Future<void> postMissionClear({
    required int missionId,
    required int userId,
  });


  // 미션 아이디로 조회.
  Future<MissionsEntity> getMissionById(int missionId);

  // 미션 클리어 유저 조회.
  Future<List<MissionClearUserHistoriesEntity>> getMissionClearUsers({
    int start = 0,
    int end = 20,
  });

  Future<List<MissionClearUserHistoriesEntity>> getMissionClearUsersByUserId(int userId);
}
