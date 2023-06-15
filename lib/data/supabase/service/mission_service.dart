import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/data/supabase/request/request_mission_update.dart';
import 'package:foresh_flutter/data/supabase/response/mission_response.dart';
import 'package:foresh_flutter/data/supabase/service_ext.dart';
import 'package:foresh_flutter/domain/supabase/entity/mission_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MissionService {
  static const _missionsTableName = "missions";

  final SupabaseClient _client;

  MissionService(this._client);

  // 모든 미션을 조회.
  Future<List<MissionEntity>> findAllMissions(bool isGlobal) async {
    try {
      final response = await _client.from(_missionsTableName).select("*").eq('is_global', isGlobal).toSelect();
      if (response.isEmpty) {
        return List.empty();
      } else {
        final missions = response.map((e) => MissionResponse.fromJson(e)).toList();
        return missions;
      }
    } on Exception catch (e) {
      throw (e.handleException()); // using extension method here
    }
  }

  // 아이디로 미션을 조회.
  Future<MissionEntity?> findMissionById(int missionId) async {
    try {
      final response = await _client.from(_missionsTableName).select("*").eq('id', missionId).toSelect();
      if (response.isEmpty) {
        return null;
      } else {
        final missions = response.map((e) => MissionResponse.fromJson(e)).toList();
        return missions.singleOrNull;
      }
    } on Exception catch (e) {
      throw (e.handleException()); // using extension method here
    }
  }

  // 미션 상태 업데이트.
  Future<MissionEntity> update(
    int id, {
    int? remainCount,
  }) async {
    try {
      MissionEntity? mission = await findMissionById(id);
      if (mission != null) {
        final updateMission = await _client
            .from(_missionsTableName)
            .update(
              RequestMissionUpdate(
                remainCount: remainCount ?? mission.remainCount,
              ).toJson(),
            )
            .eq('id', id)
            .select();
        return updateMission.map((e) => MissionResponse.fromJson(e)).toList().single;
      } else {
        throw const PostgrestException(message: '미션이 존재하지 않습니다');
      }
    } on Exception catch (e) {
      throw (e.handleException()); // using extension method here
    }
  }
}
