import 'package:fortune/domain/supabase/entity/ingredient_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'random_scratch_grid_item.freezed.dart';

@freezed
class RandomScratchGridItem with _$RandomScratchGridItem {
  factory RandomScratchGridItem({
    required IngredientEntity ingredient,
    required bool isWinner,
    required bool isScratched,
  }) = _RandomScratchGridItem;

  factory RandomScratchGridItem.initial({
    IngredientEntity? ingredient,
    bool? isWinner,
    bool? isScratched,
  }) =>
      RandomScratchGridItem(
        ingredient: ingredient ?? IngredientEntity.empty(),
        isWinner: isWinner ?? false,
        isScratched: isScratched ?? false,
      );
}
