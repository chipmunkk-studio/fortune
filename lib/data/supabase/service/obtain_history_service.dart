import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/data/supabase/request/request_obtain_history_update.dart';
import 'package:foresh_flutter/data/supabase/response/obtain_history_response.dart';
import 'package:foresh_flutter/data/supabase/service_ext.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ObtainHistoryService {
  static const _obtainHistoryTableName = "obtain_histories";

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
          .select("*,ingredient(*),user(*)")
          .or(
            'kr_location_name.ilike.$convertedQuery, '
            'en_location_name.ilike.$convertedQuery, '
            'en_ingredient_name.ilike.$convertedQuery, '
            'kr_ingredient_name.ilike.$convertedQuery, '
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

  // 마커 히스토리 삽입.
  Future<void> insert({
    required int userId,
    required String markerId,
    required int ingredientId,
    required String krLocationName,
    required String enLocationName,
    required String krIngredientName,
    required String enIngredientName,
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
              enIngredientName: enIngredientName,
              krIngredientName: krIngredientName,
            ).toJson(),
          );
    } on Exception catch (e) {
      throw (e.handleException()); // using extension method here
    }
  }
}
