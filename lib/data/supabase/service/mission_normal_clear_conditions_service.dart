import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/data/supabase/response/mission_normal_clear_conditions_response.dart';
import 'package:foresh_flutter/data/supabase/service_ext.dart';
import 'package:foresh_flutter/domain/supabase/entity/normal_mission_clear_condition_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MissionNormalClearConditionsService {
  static const _missionClearConditionTableName = "mission_normal_clear_conditions";
  static const _fullSelectQuery = '*,ingredient(*),mission(*)';

  final SupabaseClient _client;

  MissionNormalClearConditionsService(this._client);

  // 미션 아이디로 클리어 조건을 조회.
  Future<List<MissionNormalClearConditionEntity>> findMissionClearConditionByMissionId(int id) async {
    try {
      final response = await _client
          .from(_missionClearConditionTableName)
          .select(
            _fullSelectQuery,
          )
          .eq('mission', id)
          .toSelect();
      if (response.isEmpty) {
        return List.empty();
      } else {
        final missionClearConditions = response.map((e) => MissionNormalClearConditionResponse.fromJson(e)).toList();
        return missionClearConditions;
      }
    } on Exception catch (e) {
      throw (e.handleException()); // using extension method here
    }
  }
}
