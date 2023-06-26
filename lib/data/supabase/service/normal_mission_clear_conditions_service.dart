import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/data/supabase/response/normal_mission_clear_conditions_response.dart';
import 'package:foresh_flutter/data/supabase/service_ext.dart';
import 'package:foresh_flutter/domain/supabase/entity/normal_mission_clear_condition_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NormalMissionClearConditionsService {
  static const _missionClearConditionTableName = "normal_mission_clear_conditions";
  static const _fullSelectQuery = '*,ingredient(*),mission(*)';

  final SupabaseClient _client;

  NormalMissionClearConditionsService(this._client);

  // 미션 아이디로 클리어 조건을 조회.
  Future<List<NormalMissionClearConditionEntity>> findMissionClearConditionByMissionId(int id) async {
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
        final missionClearConditions = response.map((e) => NormalMissionClearConditionResponse.fromJson(e)).toList();
        return missionClearConditions;
      }
    } on Exception catch (e) {
      throw (e.handleException()); // using extension method here
    }
  }
}
