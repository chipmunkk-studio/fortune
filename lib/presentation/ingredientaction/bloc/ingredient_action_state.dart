import 'package:fortune/presentation/ingredientaction/ingredient_action_param.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ingredient_action_state.freezed.dart';

@freezed
class IngredientActionState with _$IngredientActionState {
  factory IngredientActionState({
    required IngredientActionParam entity,
  }) = _IngredientActionState;

  factory IngredientActionState.initial([
    IngredientActionParam? param,
  ]) =>
      IngredientActionState(
        entity: param ?? IngredientActionParam.empty(),
      );
}
