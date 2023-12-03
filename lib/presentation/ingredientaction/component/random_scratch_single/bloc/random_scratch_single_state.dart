import 'package:fortune/domain/supabase/entity/ingredient_entity.dart';
import 'package:fortune/presentation/ingredientaction/ingredient_action_param.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'random_scratch_single_state.freezed.dart';

@freezed
class RandomScratchSingleState with _$RandomScratchSingleState {
  factory RandomScratchSingleState({
    required bool thresholdReached,
    required List<IngredientEntity> randomScratchIngredients,
    required IngredientActionParam randomScratchSelected,
    required bool isLoading,
  }) = _RandomScratchSingleState;

  factory RandomScratchSingleState.initial([
    bool? thresholdReached,
  ]) =>
      RandomScratchSingleState(
        thresholdReached: thresholdReached ?? false,
        randomScratchIngredients: List.empty(),
        randomScratchSelected: IngredientActionParam.initial(),
        isLoading: true,
      );
}
