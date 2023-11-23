import 'package:fortune/presentation/ingredientaction/ingredient_action_param.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ingredient_action_state.freezed.dart';

@freezed
class IngredientActionState with _$IngredientActionState {
  factory IngredientActionState({
    required IngredientActionParam entity,
    required bool adMobStatus,
  }) = _IngredientActionState;

  factory IngredientActionState.initial([
    IngredientActionParam? param,
    bool? adMobStatus,
  ]) =>
      IngredientActionState(
        entity: param ?? IngredientActionParam.empty(),
        adMobStatus: adMobStatus ?? true,
      );
}
