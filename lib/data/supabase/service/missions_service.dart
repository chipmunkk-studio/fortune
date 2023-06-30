import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/data/supabase/request/request_mission_update.dart';
import 'package:foresh_flutter/data/supabase/response/missions_response.dart';
import 'package:foresh_flutter/data/supabase/service_ext.dart';
import 'package:foresh_flutter/domain/supabase/entity/mission_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MissionsService {
  static const _missionsTableName = "missions";
  static const _fullSelectQuery = '*,marker(*,ingredient(*))';

  final SupabaseClient _client;

  MissionsService(this._client);

  // 모든 노멀 미션을 조회.
  Future<List<MissionsEntity>> findAllMissions(bool isGlobal) async {
    try {
      final response = await _client
          .from(_missionsTableName)
          .select(_fullSelectQuery)
          .filter('is_active', 'eq', true)
          .filter('is_global', 'eq', isGlobal)
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
          .from(_missionsTableName)
          .select(
            _fullSelectQuery,
          )
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
          .from(_missionsTableName)
          .select(
            _fullSelectQuery,
          )
          .filter('is_active', 'eq', true)
          .filter('marker', 'eq', markerId)
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

  // 미션 상태 업데이트.
  Future<MissionsEntity> update(
    int id, {
    int? remainCount,
  }) async {
    try {
      MissionsEntity mission = await findMissionById(id);
      final updateMission = await _client
          .from(_missionsTableName)
          .update(
            RequestMissionUpdate(
              remainCount: remainCount ?? mission.remainCount,
            ).toJson(),
          )
          .eq('id', id)
          .select(_fullSelectQuery);
      return updateMission.map((e) => MissionsResponse.fromJson(e)).toList().single;
    } on Exception catch (e) {
      throw (e.handleException()); // using extension method here
    }
  }
}
