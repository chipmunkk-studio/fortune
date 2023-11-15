import 'dart:math';

import 'package:fortune/core/error/failure/custom_failure.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/data/supabase/service/ingredient_service.dart';
import 'package:fortune/data/supabase/service_ext.dart';
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
      throw e.handleFortuneFailure();
    }
  }

  // 랜덤으로 재료 하나 가져오기.
  @override
  Future<IngredientEntity> generateIngredientByRewardInfoType(AlarmRewardInfoEntity rewardInfo) async {
    try {
      List<IngredientEntity> originIngredients = await findAllIngredients();

      // 기본적으로 경우 유니크 마커만 지급.
      var outputIngredients = originIngredients.where((element) => element.type == IngredientType.unique).toList();

      // 에픽 마커들만 가져옴. > 등급 업일 경우
      if (rewardInfo.hasEpicMarker) {
        outputIngredients = originIngredients.where((element) => element.type == IngredientType.epic).toList();
      }

      // 레어 마커들만 가져옴 > 릴레이 미션일 경우 .
      if (rewardInfo.hasRareMarker) {
        outputIngredients = originIngredients.where((element) => element.type == IngredientType.rare).toList();
      }

      if (outputIngredients.isNotEmpty) {
        final random = Random();
        final ingredient = outputIngredients[random.nextInt(outputIngredients.length)];
        return ingredient;
      } else {
        throw const CustomFailure(errorDescription: '생성할 수 있는 재료가 없습니다.');
      }
    } on FortuneFailure catch (e) {
      throw e.handleFortuneFailure();
    }
  }

  @override
  Future<List<IngredientEntity>> findIngredientsByType(IngredientType type) async {
    try {
      final List<IngredientEntity> ingredients = await _ingredientService.findIngredientsByType(type);
      return ingredients;
    } on FortuneFailure catch (e) {
      throw e.handleFortuneFailure();
    }
  }
}
