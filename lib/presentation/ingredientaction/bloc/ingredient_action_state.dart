import 'package:fortune/domain/supabase/entity/ingredient_entity.dart';
import 'package:fortune/presentation/ingredientaction/ingredient_action_param.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ingredient_action_state.freezed.dart';

@freezed
class IngredientActionState with _$IngredientActionState {
  factory IngredientActionState({
    required IngredientActionParam entity,
    required List<IngredientEntity> randomScratchersItems,
    required IngredientActionParam randomScratcherSelected,
    required bool isLoading,
    required bool adMobStatus,
  }) = _IngredientActionState;

  factory IngredientActionState.initial([
    IngredientActionParam? param,
    IngredientActionParam? randomNormalSelected,
    bool? adMobStatus,
    bool? isLoading,
  ]) =>
      IngredientActionState(
        entity: param ?? IngredientActionParam.initial(),
        randomScratcherSelected: randomNormalSelected ?? IngredientActionParam.initial(),
        randomScratchersItems: List.empty(),
        adMobStatus: adMobStatus ?? true,
        isLoading: isLoading ?? true,
      );
}
