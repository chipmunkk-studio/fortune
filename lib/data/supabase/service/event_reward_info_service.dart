import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/data/supabase/supabase_ext.dart';
import 'package:foresh_flutter/data/supabase/request/request_event_reward_history.dart';
import 'package:foresh_flutter/data/supabase/response/eventnotice/event_reward_history_response.dart';
import 'package:foresh_flutter/data/supabase/response/eventnotice/event_reward_info_response.dart';
import 'package:foresh_flutter/data/supabase/service/service_ext.dart';
import 'package:foresh_flutter/domain/supabase/entity/eventnotice/event_rewards_entity.dart';
import 'package:foresh_flutter/domain/supabase/entity/eventnotice/event_rewards_history_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EventRewardInfoService {
  static const fullSelectQuery = '*';

  final _tableName = TableName.eventRewardInfo;

  final SupabaseClient _client = Supabase.instance.client;

  EventRewardInfoService();

  // 리워드 타입으로 리워드 정보 검색 검색.
  Future<EventRewardInfoEntity> findEventRewardsByType(String type) async {
    try {
      final response = await _client
          .from(_tableName)
          .select(
            fullSelectQuery,
          )
          .filter('type', 'eq', type)
          .toSelect();
      if (response.isEmpty) {
        throw CommonFailure(errorMessage: '등록된 리워드 정보가 없습니다');
      } else {
        final reward = response.map((e) => EventRewardInfoResponse.fromJson(e)).toList().single;
        return reward;
      }
    } catch (e) {
      throw (e is Exception) ? e.handleException() : e;
    }
  }
}
