import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/data/supabase/request/request_obtain_history_update.dart';
import 'package:foresh_flutter/data/supabase/response/obtain_history_response.dart';
import 'package:foresh_flutter/data/supabase/service/service_ext.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ObtainHistoryService {
  static const _obtainHistoryTableName = "obtain_histories";
  static const _fullSelectQuery = '*,ingredient(*),user(*)';

  final SupabaseClient _client;

  ObtainHistoryService(
    this._client,
  );

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
            'kr_location_name.ilike.$convertedQuery, '
            'en_location_name.ilike.$convertedQuery, '
            'ingredient_name.ilike.$convertedQuery, '
            'marker_id.ilike.$convertedQuery, '
            'nickname.ilike.$convertedQuery',
          )
          .order('created_at', ascending: false)
          .range(start, end)
          .toSelect();
      if (response.isEmpty) {
        return List.empty();
      } else {
        final histories = response.map((e) => ObtainHistoryResponse.fromJson(e)).toList();
        return histories;
      }
    } on Exception catch (e) {
      throw (e.handleException()); // using extension method here
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
          .toSelect();
      if (response.isEmpty) {
        return List.empty();
      } else {
        final histories = response.map((e) => ObtainHistoryResponse.fromJson(e)).toList();
        return histories;
      }
    } on Exception catch (e) {
      throw (e.handleException()); // using extension method here
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
    } on Exception catch (e) {
      throw (e.handleException()); // using extension method here
    }
  }

  // 마커 히스토리 삽입.
  Future<void> insert({
    required int userId,
    required String markerId,
    required int ingredientId,
    required String krLocationName,
    required String enLocationName,
    required String ingredientName,
    required String nickname,
  }) async {
    try {
      await _client.from(_obtainHistoryTableName).insert(
            RequestObtainHistoryUpdate(
              userId: userId,
              markerId: markerId,
              ingredientId: ingredientId,
              nickName: nickname,
              krLocationName: krLocationName,
              enLocationName: enLocationName,
              ingredientName: ingredientName,
            ).toJson(),
          );
    } on Exception catch (e) {
      throw (e.handleException()); // using extension method here
    }
  }

  // 히스토리 삭제.
  Future<void> delete(List<int> list) async {
    try {
      await _client.from(_obtainHistoryTableName).delete().in_('id', list);
    } on Exception catch (e) {
      throw (e.handleException()); // using extension method here
    }
  }
}
