import 'package:fortune/core/error/failure/common_failure.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/data/supabase/request/request_alarm_reward_history.dart';
import 'package:fortune/data/supabase/response/alarmfeed/alarm_feeds_response.dart';
import 'package:fortune/data/supabase/response/alarmfeed/alarm_reward_history_response.dart';
import 'package:fortune/data/supabase/service/ingredient_service.dart';
import 'package:fortune/data/supabase/service_ext.dart';
import 'package:fortune/data/supabase/supabase_ext.dart';
import 'package:fortune/domain/supabase/entity/eventnotice/alarm_rewards_history_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AlarmRewardHistoryService {
  static const fullSelectQuery = '*,'
      '${TableName.users}(*),'
      '${TableName.ingredients}(${IngredientService.fullSelectQuery}),'
      '${TableName.alarmRewardInfo}(*)';

  final _tableName = TableName.alarmRewardHistory;

  final SupabaseClient _client = Supabase.instance.client;

  AlarmRewardHistoryService();

  // 리워드 히스토리 추가.
  Future<AlarmRewardHistoryEntity> insertRewardHistory(RequestAlarmRewardHistory request) async {
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

  // 알림 리워드 업데이트.
  Future<AlarmRewardHistoryEntity> update(
    int id, {
    required RequestAlarmRewardHistory request,
  }) async {
    try {
      Map<String, dynamic> updateMap = request.toJson();

      updateMap.removeWhere((key, value) => value == null);

      final updateHistory = await _client
          .from(_tableName)
          .update(
            updateMap,
          )
          .eq(AlarmFeedColumn.id.name, id)
          .select(fullSelectQuery);

      return updateHistory.map((e) => AlarmRewardHistoryResponse.fromJson(e)).toList().single;
    } catch (e) {
      throw (e is Exception) ? e.handleException() : e;
    }
  }
}
