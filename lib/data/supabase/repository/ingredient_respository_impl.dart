import 'dart:math';

import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/core/util/logger.dart';
import 'package:foresh_flutter/data/supabase/service/ingredient_service.dart';
import 'package:foresh_flutter/data/supabase/service/user_service.dart';
import 'package:foresh_flutter/domain/supabase/entity/ingredient_entity.dart';
import 'package:foresh_flutter/domain/supabase/repository/ingredient_respository.dart';

class IngredientRepositoryImpl extends IngredientRepository {
  final IngredientService _ingredientService;

  IngredientRepositoryImpl(
    this._ingredientService,
  );

  // 맵에 뿌릴 재료들 찾기.
  @override
  Future<List<IngredientEntity>> findAllIngredients(bool isGlobal) async {
    try {
      final List<IngredientEntity> ingredients = await _ingredientService.findAllIngredients(isGlobal);
      return ingredients;
    } on FortuneFailure catch (e) {
      FortuneLogger.error('errorCode: ${e.code}, errorMessage: ${e.message}');
      rethrow;
    }
  }

  @override
  Future<IngredientEntity> getIngredientByRandom(bool isGlobal) async {
    try {
      final List<IngredientEntity> ingredients = await findAllIngredients(isGlobal);
      if (ingredients.isNotEmpty) {
        final random = Random();
        final ingredient = ingredients[random.nextInt(ingredients.length)];
        return ingredient;
      } else {
        throw CommonFailure(errorMessage: '생성할 수 있는 재료가 없습니다.');
      }
    } on FortuneFailure catch (e) {
      FortuneLogger.error('errorCode: ${e.code}, errorMessage: ${e.message}');
      rethrow;
    }
  }
}
