import 'package:fortune/presentation/ingredientaction/component/random_scratch_multi/bloc/random_scratch_grid_item.dart';
import 'package:fortune/presentation/ingredientaction/ingredient_action_param.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'random_scratch_multi_state.freezed.dart';

@freezed
class RandomScratchMultiState with _$RandomScratchMultiState {
  factory RandomScratchMultiState({
    required List<RandomScratchGridItem> gridItems,
    required IngredientActionParam randomScratchSelected,
  }) = _RandomScratchMultiState;

  factory RandomScratchMultiState.initial([
    List<RandomScratchGridItem>? gridItems,
    IngredientActionParam? randomScratchSelected,
  ]) =>
      RandomScratchMultiState(
        randomScratchSelected: randomScratchSelected ?? IngredientActionParam.empty(),
        gridItems: List.empty(),
      );
}
