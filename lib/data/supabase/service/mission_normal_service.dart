import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/data/supabase/request/request_mission_update.dart';
import 'package:foresh_flutter/data/supabase/response/mission_normal_response.dart';
import 'package:foresh_flutter/data/supabase/service_ext.dart';
import 'package:foresh_flutter/domain/supabase/entity/normal_mission_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MissionNormalService {
  static const _normalMissionsTableName = "mission_normal";
  static const _fullSelectQuery = '*';

  final SupabaseClient _client;

  MissionNormalService(this._client);

  // 모든 노멀 미션을 조회.
  Future<List<MissionNormalEntity>> findAllMissions(bool isGlobal) async {
    try {
      final response = await _client
          .from(_normalMissionsTableName)
          .select(_fullSelectQuery)
          .eq(
            'is_global',
            isGlobal,
          )
          .toSelect();
      if (response.isEmpty) {
        return List.empty();
      } else {
        final missions = response.map((e) => MissionNormalResponse.fromJson(e)).toList();
        return missions;
      }
    } on Exception catch (e) {
      throw (e.handleException()); // using extension method here
    }
  }

  // 아이디로 미션을 조회.
  Future<MissionNormalEntity> findMissionById(int missionId) async {
    try {
      final response = await _client
          .from(_normalMissionsTableName)
          .select(
            _fullSelectQuery,
          )
          .eq('id', missionId)
          .toSelect();
      if (response.isEmpty) {
        throw CommonFailure(errorMessage: '미션이 존재하지 않습니다');
      } else {
        final missions = response.map((e) => MissionNormalResponse.fromJson(e)).toList();
        return missions.single;
      }
    } on Exception catch (e) {
      throw (e.handleException()); // using extension method here
    }
  }

  // 아이디로 미션을 조회.
  Future<MissionNormalEntity> findMissionByMarkerId(int markerId) async {
    try {
      final response = await _client
          .from(_normalMissionsTableName)
          .select(
            _fullSelectQuery,
          )
          .eq('marker', markerId)
          .toSelect();
      if (response.isEmpty) {
        throw CommonFailure(errorMessage: '미션이 존재 하지 않습니다');
      } else {
        final missions = response.map((e) => MissionNormalResponse.fromJson(e)).toList();
        return missions.single;
      }
    } on Exception catch (e) {
      throw (e.handleException()); // using extension method here
    }
  }

  // 미션 상태 업데이트.
  Future<MissionNormalEntity> update(
    int id, {
    int? remainCount,
  }) async {
    try {
      MissionNormalEntity mission = await findMissionById(id);
      final updateMission = await _client
          .from(_normalMissionsTableName)
          .update(
            RequestMissionUpdate(
              remainCount: remainCount ?? mission.remainCount,
            ).toJson(),
          )
          .eq('id', id)
          .select(_fullSelectQuery);
      return updateMission.map((e) => MissionNormalResponse.fromJson(e)).toList().single;
    } on Exception catch (e) {
      throw (e.handleException()); // using extension method here
    }
  }
}
