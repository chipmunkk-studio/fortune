import 'package:fortune/domain/supabase/entity/ingredient_entity.dart';

class IngredientActionResponse {
  final IngredientEntity ingredient;
  final bool result;

  IngredientActionResponse({
    required this.ingredient,
    required this.result,
  });
}
