import 'package:foresh_flutter/core/error/failure/common_failure.dart';
import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/data/supabase/supabase_ext.dart';
import 'package:foresh_flutter/data/supabase/response/mission/missions_response.dart';
import 'package:foresh_flutter/data/supabase/service/marker_service.dart';
import 'package:foresh_flutter/data/supabase/service/service_ext.dart';
import 'package:foresh_flutter/domain/supabase/entity/mission/missions_entity.dart';
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
        return missions;
      }
    } on Exception catch (e) {
      throw (e.handleException()); // using extension method here
    }
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
