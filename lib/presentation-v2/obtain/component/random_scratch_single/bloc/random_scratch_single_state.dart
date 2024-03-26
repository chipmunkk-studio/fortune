import 'package:fortune/domain/entity/picked_item_entity.dart';
import 'package:fortune/domain/entity/scratch_cover_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'random_scratch_single_state.freezed.dart';

@freezed
class RandomScratchSingleState with _$RandomScratchSingleState {
  factory RandomScratchSingleState({
    required bool thresholdReached,
    required PickedItemEntity pickedItemEntity,
    required ScratchCoverEntity scratchCoverEntity,
    required bool isLoading,
  }) = _RandomScratchSingleState;

  factory RandomScratchSingleState.initial([
    bool? thresholdReached,
  ]) =>
      RandomScratchSingleState(
        thresholdReached: thresholdReached ?? false,
        pickedItemEntity: PickedItemEntity.initial(),
        scratchCoverEntity: ScratchCoverEntity.initial(),
        isLoading: true,
      );
}
