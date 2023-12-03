import 'dart:math' as math;

import 'package:fortune/core/util/logger.dart';
import 'package:fortune/data/supabase/service_ext.dart';
import 'package:fortune/domain/supabase/entity/ingredient_entity.dart';

collectTesting(List<IngredientEntity> randomNormalIngredients) {
  int listLength = randomNormalIngredients.length; // 실제 randomNormalIngredients 리스트의 길이로 대체
  int numSamples = 1000;
  List<int> randomIndices = [];

  for (int i = 0; i < numSamples; i++) {
    int randomIndex = math.Random().nextInt(listLength);
    randomIndices.add(randomIndex);
  }

  final temp = randomIndices
      .where(
        (element) =>
            randomNormalIngredients[element].type == IngredientType.randomScratchMultiOnly ||
            randomNormalIngredients[element].type == IngredientType.randomScratchSingleOnly,
      )
      .toList();

  FortuneLogger.info("당첨 갯수: $temp,");
}
