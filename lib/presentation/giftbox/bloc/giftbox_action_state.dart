import 'package:fortune/domain/supabase/entity/ingredient_entity.dart';
import 'package:fortune/presentation/giftbox/giftbox_action_param.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'giftbox_action_state.freezed.dart';

@freezed
class GiftboxActionState with _$GiftboxActionState {
  factory GiftboxActionState({
    required GiftboxActionParam entity,
    required List<IngredientEntity> randomScratchersItems,
    required GiftboxActionParam randomScratcherSelected,
    required bool isLoading,
    required bool isReadyToAd,
  }) = _GiftboxActionState;

  factory GiftboxActionState.initial([
    GiftboxActionParam? param,
    GiftboxActionParam? randomNormalSelected,
    bool? isReadyToAd,
    bool? isLoading,
  ]) =>
      GiftboxActionState(
        entity: param ?? GiftboxActionParam.initial(),
        randomScratcherSelected: randomNormalSelected ?? GiftboxActionParam.initial(),
        randomScratchersItems: List.empty(),
        isReadyToAd: isReadyToAd ?? false,
        isLoading: isLoading ?? true,
      );
}
