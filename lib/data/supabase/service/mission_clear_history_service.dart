import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/data/supabase/response/mission_clear_history_response.dart';
import 'package:foresh_flutter/data/supabase/service_ext.dart';
import 'package:foresh_flutter/domain/supabase/entity/mission_clear_history_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MissionClearHistoryService {
  static const _missionClearHistoryTableName = "mission_clear_history";

  final SupabaseClient _client;

  MissionClearHistoryService(this._client);

  // 유저 아이디로 미션 클리어 히스토리 조회.
  Future<List<MissionClearHistoryEntity>> findAllMissionClearHistoryById(int id) async {
    try {
      final response = await _client.from(_missionClearHistoryTableName).select("*").eq('user_id', id).toSelect();
      if (response.isEmpty) {
        return List.empty();
      } else {
        final missionClearHistories = response.map((e) => MissionClearHistoryResponse.fromJson(e)).toList();
        return missionClearHistories;
      }
    } on Exception catch (e) {
      throw (e.handleException()); // using extension method here
    }
  }
}
