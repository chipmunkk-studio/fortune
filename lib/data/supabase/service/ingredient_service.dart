import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/data/supabase/response/ingredient_response.dart';
import 'package:foresh_flutter/data/supabase/service_ext.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class IngredientService {
  static const _ingredientTableName = "ingredients";

  final SupabaseClient _client;

  IngredientService(
    this._client,
  );

  Future<List<IngredientResponse>> findIngredients(bool isGlobal) async {
    try {
      final List<dynamic> response = await _client
          .from(_ingredientTableName)
          .select("*")
          .or(
            'type.eq.ticket,'
            'is_global.eq.$isGlobal',
          )
          .toSelect();
      if (response.isEmpty) {
        return List.empty();
      } else {
        final ingredients = response.map((e) => IngredientResponse.fromJson(e)).toList();
        return ingredients;
      }
    } on Exception catch (e) {
      throw (e.handleException()); // using extension method here
    }
  }
}
