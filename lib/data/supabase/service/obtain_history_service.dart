import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/data/supabase/request/request_obtain_history.dart';
import 'package:fortune/data/supabase/response/obtain_history_response.dart';
import 'package:fortune/data/supabase/service/service_ext.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ObtainHistoryService {
  static const _obtainHistoryTableName = "obtain_histories";
  static const _fullSelectQuery = '*,ingredient(*),user(*)';

  final SupabaseClient _client = Supabase.instance.client;

  ObtainHistoryService();

  Future<List<ObtainHistoryResponse>> findObtainHistories({
    required int start,
    required int end,
    required String query,
  }) async {
    try {
      final convertedQuery = '%$query%';
      final List<dynamic> response = await _client
          .from(_obtainHistoryTableName)
          .select(_fullSelectQuery)
          .or(
            'location_name.ilike.$convertedQuery, '
            'kr_ingredient_name.ilike.$convertedQuery, '
            'en_ingredient_name.ilike.$convertedQuery, '
            'marker_id.ilike.$convertedQuery, '
            'nickname.ilike.$convertedQuery',
          )
          .filter('is_reward', 'eq', false)
          .order('created_at', ascending: false)
          .range(start, end)
          .toSelect();
      if (response.isEmpty) {
        return List.empty();
      } else {
        final histories = response.map((e) => ObtainHistoryResponse.fromJson(e)).toList();
        return histories;
      }
    } catch (e) {
      throw (e is Exception) ? e.handleException() : e;
    }
  }

  Future<List<ObtainHistoryResponse>> findObtainHistoryByUserAndIngredient({
    required int userId,
    required int ingredientId,
  }) async {
    try {
      final List<dynamic> response = await _client
          .from(_obtainHistoryTableName)
          .select(_fullSelectQuery)
          .eq('user', userId)
          .eq('ingredient', ingredientId)
          .order('created_at', ascending: false)
          .toSelect();
      if (response.isEmpty) {
        return List.empty();
      } else {
        final histories = response.map((e) => ObtainHistoryResponse.fromJson(e)).toList();
        return histories;
      }
    } catch (e) {
      throw (e is Exception) ? e.handleException() : e;
    }
  }

  Future<List<ObtainHistoryResponse>> findObtainHistoryByUser({
    required int userId,
  }) async {
    try {
      final List<dynamic> response = await _client
          .from(_obtainHistoryTableName)
          .select(_fullSelectQuery)
          .eq(
            'user',
            userId,
          )
          .toSelect();
      if (response.isEmpty) {
        return List.empty();
      } else {
        final histories = response.map((e) => ObtainHistoryResponse.fromJson(e)).toList();
        return histories;
      }
    } catch (e) {
      throw (e is Exception) ? e.handleException() : e;
    }
  }

  // 마커 히스토리 삽입.
  Future<void> insert({required RequestObtainHistory request}) async {
    try {
      await _client.from(_obtainHistoryTableName).insert(request.toJson());
    } catch (e) {
      throw (e is Exception) ? e.handleException() : e;
    }
  }

  // 히스토리 삭제.
  Future<void> delete(List<int> list) async {
    try {
      await _client.from(_obtainHistoryTableName).delete().in_('id', list);
    } catch (e) {
      throw (e is Exception) ? e.handleException() : e;
    }
  }
}
