import 'dart:math';

import 'package:collection/collection.dart';
import 'package:fortune/core/error/failure/custom_failure.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/data/supabase/service/ingredient_service.dart';
import 'package:fortune/data/supabase/service/service_ext.dart';
import 'package:fortune/domain/supabase/entity/eventnotice/alarm_rewards_entity.dart';
import 'package:fortune/domain/supabase/entity/ingredient_entity.dart';
import 'package:fortune/domain/supabase/repository/ingredient_respository.dart';

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
      throw e.handleFortuneFailure(
        description: '재료 불러오기 실패',
      );
    }
  }

  // 랜덤으로 재료 하나 가져오기.
  @override
  Future<IngredientEntity> getIngredientByRandom(AlarmRewardInfoEntity rewardType) async {
    try {
      List<IngredientEntity> ingredients = await findAllIngredients();

      if (!rewardType.hasUniqueMarker) {
        ingredients = ingredients.whereNot((element) => element.type == IngredientType.unique).toList();
      }

      if (ingredients.isNotEmpty) {
        final random = Random();
        final ingredient = ingredients[random.nextInt(ingredients.length)];
        return ingredient;
      } else {
        throw const CustomFailure(errorDescription: '생성할 수 있는 재료가 없습니다.');
      }
    } on FortuneFailure catch (e) {
      throw e.handleFortuneFailure(
        description: '재료 가져오기 실패',
      );
    }
  }
}
