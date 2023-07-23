import 'dart:math';

import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/core/util/logger.dart';
import 'package:foresh_flutter/data/supabase/service/ingredient_service.dart';
import 'package:foresh_flutter/domain/supabase/entity/ingredient_entity.dart';
import 'package:foresh_flutter/domain/supabase/repository/ingredient_respository.dart';

class IngredientRepositoryImpl extends IngredientRepository {
  final IngredientService _ingredientService;

  IngredientRepositoryImpl(
    this._ingredientService,
  );

  // 맵에 뿌릴 재료들 찾기.
  @override
  Future<List<IngredientEntity>> findAllIngredients() async {
    try {
      final List<IngredientEntity> ingredients = await _ingredientService.findAllIngredients();
      return ingredients;
    } on FortuneFailure catch (e) {
      FortuneLogger.error('errorCode: ${e.code}, errorMessage: ${e.message}');
      rethrow;
    }
  }

  // 랜덤으로 재료 하나 가져오기.
  @override
  Future<IngredientEntity> getIngredientByRandom() async {
    try {
      final List<IngredientEntity> ingredients = await findAllIngredients();
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
