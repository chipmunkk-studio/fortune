import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/data/supabase/response/alarmfeed/alarm_reward_history_response.dart';
import 'package:foresh_flutter/data/supabase/supabase_ext.dart';
import 'package:foresh_flutter/data/supabase/request/request_event_reward_history.dart';
import 'package:foresh_flutter/domain/supabase/entity/eventnotice/alarm_rewards_history_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AlarmRewardHistoryService {
  static const fullSelectQuery = '*,'
      '${TableName.users}(*),'
      '${TableName.alarmRewardInfo}(*)';

  final _tableName = TableName.alarmRewardHistory;

  final SupabaseClient _client = Supabase.instance.client;

  AlarmRewardHistoryService();

  // 리워드 히스토리 추가.
  Future<AlarmRewardHistoryEntity> insertRewardHistory(RequestEventRewardHistory request) async {
    try {
      final response = await _client
          .from(
            _tableName,
          )
          .insert(request.toJson())
          .select(fullSelectQuery);
      if (response.isEmpty) {
        throw CommonFailure(errorMessage: '리워드 추가 실패');
      } else {
        final reward = response.map((e) => AlarmRewardHistoryResponse.fromJson(e)).toList().single;
        return reward;
      }
    } catch (e) {
      throw (e is Exception) ? e.handleException() : e;
    }
  }
}
