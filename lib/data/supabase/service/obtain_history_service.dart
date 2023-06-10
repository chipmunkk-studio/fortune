import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/data/supabase/request/request_obtain_history_update.dart';
import 'package:foresh_flutter/data/supabase/response/obtain_history_response.dart';
import 'package:foresh_flutter/data/supabase/service_ext.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ObtainHistoryService {
  static const _obtainHistoryTableName = "obtain_history";
  static const _tag = '[ObtainHistoryService] ';

  final SupabaseClient _client;

  ObtainHistoryService(
    this._client,
  );

  //
  Future<List<ObtainHistoryResponse>> findObtainHistories() async {
    try {
      final List<dynamic> response = await _client.from(_obtainHistoryTableName).select("*").toSelect();
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
    required String nickname,
    required String ingredientImage,
    required String location,
    required String locationKr,
    required String krIngredientName,
    required String enIngredientName,
    required String ingredientType,
  }) async {
    try {
      await _client.from(_obtainHistoryTableName).insert(
            RequestObtainHistoryUpdate(
              nickname: nickname,
              ingredientImage: ingredientImage,
              krIngredientName: krIngredientName,
              enIngredientName: enIngredientName,
              location: location,
              locationKr: locationKr,
              ingredientType: ingredientType,
            ).toJson(),
          );
    } on Exception catch (e) {
      throw (e.handleException()); // using extension method here
    }
  }
}
