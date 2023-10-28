import 'dart:math' as math;

import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/data/supabase/response/mission/mission_ext.dart';
import 'package:fortune/data/supabase/response/mission/mission_reward_response.dart';
import 'package:fortune/data/supabase/response/mission/missions_response.dart';
import 'package:fortune/data/supabase/service_ext.dart';
import 'package:fortune/data/supabase/supabase_ext.dart';
import 'package:fortune/domain/supabase/entity/mission/missions_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MissionsService {
  static const fullSelectQuery = "*,"
      "${TableName.missionReward}(*)";

  final SupabaseClient _client = Supabase.instance.client;

  MissionsService();

  // 진행 가능 한 모든 미션을 조회.
  Future<List<MissionsEntity>> findAllMissions() async {
    // 조회 해야 할 컬럼.
    final columnsToSelect = [
      MissionsColumn.id,
      MissionsColumn.missionReward,
      MissionsColumn.missionType,
      MissionsColumn.missionImage,
      MissionsColumn.isActive,
      MissionsColumn.enTitle,
      MissionsColumn.enContent,
      MissionsColumn.krTitle,
      MissionsColumn.krContent,
      MissionsColumn.deadline,
    ];

    final selectColumns = columnsToSelect.map((column) {
      if (column == MissionsColumn.missionReward) {
        return '${TableName.missionReward}(${MissionRewardColumn.remainCount.name},${MissionRewardColumn.totalCount.name})';
      }
      return column.name;
    }).toList();

    try {
      final response = await _client
          .from(
            TableName.missions,
          )
          .select(selectColumns.join(","))
          .filter(MissionsColumn.isActive.name, 'eq', true)
          .toSelect();
      if (response.isEmpty) {
        return List.empty();
      } else {
        final missions = response.map((e) => MissionsResponse.fromJson(e)).toList();
        final filteredGradeMissions = _modifyListWithRandomGrade(missions);
        return filteredGradeMissions;
      }
    } on Exception catch (e) {
      throw (e.handleException()); // using extension method here
    }
  }

  List<MissionsEntity> _modifyListWithRandomGrade(List<MissionsEntity> missions) {
    // missionType이 grade인 항목만 필터링
    final gradeMissions = missions.where((mission) => mission.type == MissionType.grade).toList();

    if (gradeMissions.isEmpty) {
      return missions; // grade 미션 항목이 없으면 원래의 리스트를 반환
    }

    // 무작위로 grade 미션 선택
    math.Random random = math.Random();
    int randomIndex = random.nextInt(gradeMissions.length);
    MissionsEntity selectedMission = gradeMissions[randomIndex];

    // 원래의 리스트에서 모든 grade 미션을 제거
    missions.removeWhere((mission) => mission.type == MissionType.grade);

    // 무작위로 선택한 grade 미션을 리스트에 추가
    missions.add(selectedMission);

    return missions;
  }

  // 아이디로 미션을 조회.
  Future<MissionsEntity> findMissionById(int missionId) async {
    try {
      final response = await _client
          .from(TableName.missions)
          .select(fullSelectQuery)
          .filter(MissionsColumn.isActive.name, 'eq', true)
          .filter(MissionsColumn.id.name, 'eq', missionId)
          .single();
      final missions = MissionsResponse.fromJson(response);
      return missions;
    } on Exception catch (e) {
      throw (e.handleException()); // using extension method here
    }
  }
}
