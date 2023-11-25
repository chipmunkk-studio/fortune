import 'package:fortune/domain/supabase/entity/ingredient_entity.dart';
import 'package:fortune/presentation/ingredientaction/ingredient_action_param.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'random_scratch_single_state.freezed.dart';

@freezed
class RandomScratchSingleState with _$RandomScratchSingleState {
  factory RandomScratchSingleState({
    required double brushSize,
    required double progress,
    required double threshold,
    required bool thresholdReached,
    required double size,
    required List<IngredientEntity> randomNormalIngredients,
    required IngredientActionParam randomNormalSelected,
  }) = _RandomScratchSingleState;

  factory RandomScratchSingleState.initial([
    double? brushSize,
    double? progress,
    double? threshold,
    bool? thresholdReached,
  ]) =>
      RandomScratchSingleState(
        brushSize: brushSize ?? 48,
        progress: progress ?? 0,
        threshold: threshold ?? 50,
        size: 200,
        thresholdReached: thresholdReached ?? false,
        randomNormalIngredients: List.empty(),
        randomNormalSelected: IngredientActionParam.empty(),
      );
}
