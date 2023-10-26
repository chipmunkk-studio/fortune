import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/data/supabase/response/ingredient_response.dart';
import 'package:fortune/data/supabase/response/mission/mission_clear_conditions_response.dart';
import 'package:fortune/data/supabase/response/mission/missions_response.dart';
import 'package:fortune/data/supabase/service/marker_service.dart';
import 'package:fortune/data/supabase/service/mission/missions_service.dart';
import 'package:fortune/data/supabase/service_ext.dart';
import 'package:fortune/data/supabase/supabase_ext.dart';
import 'package:fortune/domain/supabase/entity/mission/mission_clear_condition_entity.dart';
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
  Future<List<MissionClearConditionEntity>> findMissionClearConditionByMissionId(int missionId) async {
    final columnsToSelect = [
      MissionClearConditionColumn.id,
      MissionClearConditionColumn.ingredients,
      MissionClearConditionColumn.requireCount,
      MissionClearConditionColumn.markers,
      MissionClearConditionColumn.missions,
    ];

    final selectColumns = columnsToSelect.map((column) {
      if (column == MissionClearConditionColumn.ingredients) {
        return '${TableName.ingredients}('
            '${IngredientColumn.id.name},'
            '${IngredientColumn.imageUrl.name},'
            '${IngredientColumn.krName.name},'
            '${IngredientColumn.enName.name}'
            ')';
      } else if (column == MissionClearConditionColumn.missions) {
        return '${TableName.missions}('
            '${MissionsColumn.missionType.name}'
            ')';
      } else if (column == MissionClearConditionColumn.markers) {
        return "${TableName.markers}(${MarkerService.fullSelectQuery})";
      }
      return column.name;
    }).toList();

    try {
      final response = await _client
          .from(_missionClearConditionTableName)
          .select(selectColumns.join(","))
          .eq(TableName.missions, missionId)
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
    final columnsToSelect = [
      MissionClearConditionColumn.requireCount,
      MissionClearConditionColumn.missions,
    ];

    final selectColumns = columnsToSelect.map((column) {
      if (column == MissionClearConditionColumn.missions) {
        return '${TableName.missions}('
            '${MissionsColumn.missionType.name},'
            '${MissionsColumn.id.name}'
            ')';
      }
      return column.name;
    }).toList();

    try {
      final response = await _client
          .from(_missionClearConditionTableName)
          .select(selectColumns.join(","))
          .eq(TableName.markers, id)
          .toSelect();
      if (response.isEmpty) {
        return null;
      } else {
        final missionClearConditions = response
            .map(
              (e) => MissionClearConditionResponse.fromJson(e),
            )
            .toList()
            .single;
        return missionClearConditions;
      }
    } on Exception catch (e) {
      throw (e.handleException()); // using extension method here
    }
  }
}
