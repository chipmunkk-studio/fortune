import 'package:fortune/core/error/failure/common_failure.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/data/supabase/request/request_alarm_reward_history.dart';
import 'package:fortune/data/supabase/response/alarmfeed/alarm_reward_history_response.dart';
import 'package:fortune/data/supabase/service/ingredient_service.dart';
import 'package:fortune/data/supabase/service/service_ext.dart';
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

  // 리워드 타입으로 리워드 정보 검색.
  Future<AlarmRewardHistoryEntity> findRewardHistoryById(int id) async {
    try {
      final response = await _client
          .from(_tableName)
          .select(
            fullSelectQuery,
          )
          .filter('id', 'eq', id)
          .toSelect();
      if (response.isEmpty) {
        throw CommonFailure(errorMessage: '등록된 리워드 정보가 없습니다');
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
      AlarmRewardHistoryEntity history = await findRewardHistoryById(id);

      final requestToUpdate = RequestAlarmRewardHistory(
        alarmRewardInfo: request.alarmRewardInfo ?? history.alarmRewardInfo.id,
        user: request.user ?? history.user.id,
        ingredients: request.ingredients ?? history.ingredients.id,
        isReceive: request.isReceive ?? history.isReceive,
      );

      final updateHistory = await _client
          .from(_tableName)
          .update(
            requestToUpdate.toJson(),
          )
          .eq('id', id)
          .select(fullSelectQuery);

      return updateHistory.map((e) => AlarmRewardHistoryResponse.fromJson(e)).toList().single;
    } catch (e) {
      throw (e is Exception) ? e.handleException() : e;
    }
  }
}
