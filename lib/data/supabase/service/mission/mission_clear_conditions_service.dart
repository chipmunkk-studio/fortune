import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/data/supabase/response/mission/mission_clear_conditions_response.dart';
import 'package:foresh_flutter/data/supabase/service/marker_service.dart';
import 'package:foresh_flutter/data/supabase/service/mission/missions_service.dart';
import 'package:foresh_flutter/data/supabase/service/service_ext.dart';
import 'package:foresh_flutter/data/supabase/supabase_ext.dart';
import 'package:foresh_flutter/domain/supabase/entity/mission/mission_clear_condition_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MissionsClearConditionsService {
  static const _missionClearConditionTableName = "mission_clear_conditions";
  static const _fullSelectQuery = '*,'
      '${TableName.missions}(${MissionsService.fullSelectQuery}),'
      '${TableName.markers}(${MarkerService.fullSelectQuery}),'
      '${TableName.ingredients}(*)';

  final SupabaseClient _client = Supabase.instance.client;

  MissionsClearConditionsService();

  // 미션 아이디로 클리어 조건을 조회.
  Future<List<MissionClearConditionEntity>> findMissionClearConditionByMissionId(int id) async {
    try {
      final response = await _client
          .from(_missionClearConditionTableName)
          .select(
            _fullSelectQuery,
          )
          .eq(TableName.missions, id)
          .toSelect();
      if (response.isEmpty) {
        return List.empty();
      } else {
        final missionClearConditions = response.map((e) => MissionClearConditionResponse.fromJson(e)).toList();
        return missionClearConditions;
      }
    } on Exception catch (e) {
      throw (e.handleException()); // using extension method here
    }
  }

  // 마커 아이디로 클리어 조건을 조회. (릴레이미션)
  Future<MissionClearConditionEntity?> findMissionClearConditionOrNullByMarkerId(int id) async {
    try {
      final response = await _client
          .from(_missionClearConditionTableName)
          .select(
            _fullSelectQuery,
          )
          .eq(TableName.markers, id)
          .toSelect();
      if (response.isEmpty) {
        return null;
      } else {
        final missionClearConditions = response.map((e) => MissionClearConditionResponse.fromJson(e)).toList().single;
        return missionClearConditions;
      }
    } on Exception catch (e) {
      throw (e.handleException()); // using extension method here
    }
  }
}
