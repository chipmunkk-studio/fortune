import 'package:foresh_flutter/domain/supabase/entity/ingredient_entity.dart';

abstract class IngredientRepository {
  // 재료들 모두 가져오기
  Future<List<IngredientEntity>> findAllIngredients(bool isGlobal);

  // 재료 랜덤으로 하나 가져오기
  Future<IngredientEntity> getIngredientByRandom(bool isGlobal);
}
