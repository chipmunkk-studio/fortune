import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/data/supabase/request/request_mission_reward_update.dart';
import 'package:fortune/data/supabase/response/mission/mission_reward_response.dart';
import 'package:fortune/data/supabase/supabase_ext.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MissionRewardService {
  static const fullSelectQuery = '*';

  final SupabaseClient _client = Supabase.instance.client;

  MissionRewardService();

  // 미션 리워드 업데이트.
  Future<MissionRewardResponse> update(
    int id, {
    required RequestMissionRewardUpdate request,
  }) async {
    try {
      Map<String, dynamic> updateMap = request.toJson();

      updateMap.removeWhere((key, value) => value == null);

      final updateMission = await _client
          .from(TableName.missionReward)
          .update(
            updateMap,
          )
          .eq(MissionRewardColumn.id.name, id)
          .select(fullSelectQuery);
      return updateMission.map((e) => MissionRewardResponse.fromJson(e)).toList().single;
    } catch (e) {
      throw (e is Exception) ? e.handleException() : e;
    }
  }
}
