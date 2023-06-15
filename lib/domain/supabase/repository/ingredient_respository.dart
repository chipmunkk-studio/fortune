import 'package:foresh_flutter/domain/supabase/entity/ingredient_entity.dart';

abstract class IngredientRepository {
  // 맵에 뿌릴 재료들 찾기.
  Future<List<IngredientEntity>> getIngredients(bool isGlobal);
}
