import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/data/supabase/request/request_mission_clear_history_update.dart';
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

  // 미션 클리어 사용자 추가.
  Future<MissionClearHistoryEntity> insert({
    required int userId,
    required String title,
    required String subtitle,
    required String rewardImage,
  }) async {
    try {
      final insertHistory = await _client
          .from(_missionClearHistoryTableName)
          .insert(
            RequestMissionClearHistoryUpdate(
              userId: userId,
              title: title,
              subtitle: subtitle,
              rewardImage: rewardImage,
            ).toJson(),
          )
          .select('*');
      return insertHistory.map((e) => MissionClearHistoryResponse.fromJson(e)).toList().single;
    } on Exception catch (e) {
      throw (e.handleException()); // using extension method here
    }
  }
}
