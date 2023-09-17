import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/data/supabase/response/ingredient_response.dart';
import 'package:fortune/data/supabase/service/service_ext.dart';
import 'package:fortune/domain/supabase/entity/ingredient_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class IngredientService {
  static const _ingredientTableName = "ingredients";
  static const fullSelectQuery = '*';

  final SupabaseClient _client;

  IngredientService(
    this._client,
  );

  // 모든 재료 가져오기.
  Future<List<IngredientEntity>> findAllIngredients() async {
    try {
      final List<dynamic> response = await _client.from(_ingredientTableName).select("*").toSelect();
      if (response.isEmpty) {
        return List.empty();
      } else {
        final ingredients = response.map((e) => IngredientResponse.fromJson(e)).toList();
        return ingredients;
      }
    } catch (e) {
      throw (e is Exception) ? e.handleException() : e;
    }
  }
}
