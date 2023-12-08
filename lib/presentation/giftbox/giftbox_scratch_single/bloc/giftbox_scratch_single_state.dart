import 'package:fortune/domain/supabase/entity/ingredient_entity.dart';
import 'package:fortune/presentation/giftbox/giftbox_action_param.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'giftbox_scratch_single_state.freezed.dart';

@freezed
class GiftboxScratchSingleState with _$GiftboxScratchSingleState {
  factory GiftboxScratchSingleState({
    required bool thresholdReached,
    required List<IngredientEntity> randomScratchIngredients,
    required GiftboxActionParam randomScratchSelected,
    required bool isLoading,
  }) = _GiftboxScratchSingleState;

  factory GiftboxScratchSingleState.initial([
    bool? thresholdReached,
  ]) =>
      GiftboxScratchSingleState(
        thresholdReached: thresholdReached ?? false,
        randomScratchIngredients: List.empty(),
        randomScratchSelected: GiftboxActionParam.initial(),
        isLoading: true,
      );
}
