import 'package:fortune/domain/supabase/entity/ingredient_entity.dart';

abstract class IngredientActionResponse {}

class ObtainSuccess extends IngredientActionResponse {
  final IngredientEntity ingredient;

  ObtainSuccess({
    required this.ingredient,
  });
}

class NoAds extends IngredientActionResponse {}

class ScratchCancel extends IngredientActionResponse {}
