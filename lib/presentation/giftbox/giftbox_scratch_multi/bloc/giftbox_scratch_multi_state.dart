import 'package:fortune/presentation/giftbox/giftbox_action_param.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'giftbox_scratch_grid_item.dart';

part 'giftbox_scratch_multi_state.freezed.dart';

@freezed
class GiftboxScratchMultiState with _$GiftboxScratchMultiState {
  factory GiftboxScratchMultiState({
    required List<GiftboxScratchGridItem> gridItems,
    required GiftboxActionParam randomScratchSelected,
    required bool isLoading,
    required bool isObtaining,
  }) = _GiftboxScratchMultiState;

  factory GiftboxScratchMultiState.initial([
    List<GiftboxScratchGridItem>? gridItems,
    GiftboxActionParam? randomScratchSelected,
  ]) =>
      GiftboxScratchMultiState(
        randomScratchSelected: randomScratchSelected ?? GiftboxActionParam.initial(),
        gridItems: List.empty(),
        isLoading: true,
        isObtaining: false,
      );
}
