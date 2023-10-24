import 'dart:math' as math;

import 'package:fortune/core/error/failure/common_failure.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/data/supabase/response/mission/mission_ext.dart';
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
    try {
      final response = await _client
          .from(
            TableName.missions,
          )
          .select(fullSelectQuery)
          .filter('is_active', 'eq', true)
          .toSelect();
      if (response.isEmpty) {
        return List.empty();
      } else {
        final missions = response.map((e) => MissionsResponse.fromJson(e)).toList();
        final filteredGradeMissions = modifyListWithRandomGrade(missions);
        return filteredGradeMissions;
      }
    } on Exception catch (e) {
      throw (e.handleException()); // using extension method here
    }
  }

  List<MissionsEntity> modifyListWithRandomGrade(List<MissionsEntity> missions) {
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
          .filter('is_active', 'eq', true)
          .filter('id', 'eq', missionId)
          .toSelect();
      if (response.isEmpty) {
        throw CommonFailure(errorMessage: '미션이 존재하지 않습니다');
      } else {
        final missions = response.map((e) => MissionsResponse.fromJson(e)).toList();
        return missions.single;
      }
    } on Exception catch (e) {
      throw (e.handleException()); // using extension method here
    }
  }

  // 마커 아이디로 미션을 조회.
  Future<MissionsEntity> findMissionByMarkerId(int markerId) async {
    try {
      final response = await _client
          .from(TableName.missions)
          .select(fullSelectQuery)
          .filter('is_active', 'eq', true)
          .filter('markers', 'eq', markerId)
          .toSelect();
      if (response.isEmpty) {
        throw CommonFailure(errorMessage: '미션이 존재 하지 않습니다');
      } else {
        final missions = response.map((e) => MissionsResponse.fromJson(e)).toList();
        return missions.single;
      }
    } on Exception catch (e) {
      throw (e.handleException()); // using extension method here
    }
  }

  // 마커 아이디로 미션을 조회.
  Future<MissionsEntity?> findMissionOrNullByMarkerId(int markerId) async {
    try {
      final response = await _client
          .from(TableName.missions)
          .select(fullSelectQuery)
          .filter('is_active', 'eq', true)
          .filter('markers', 'eq', markerId)
          .toSelect();
      if (response.isEmpty) {
        return null;
      } else {
        final missions = response.map((e) => MissionsResponse.fromJson(e)).toList();
        return missions.single;
      }
    } on Exception catch (e) {
      throw (e.handleException()); // using extension method here
    }
  }
}
