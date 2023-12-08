import 'package:fortune/domain/supabase/entity/ingredient_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'giftbox_scratch_grid_item.freezed.dart';

@freezed
class GiftboxScratchGridItem with _$GiftboxScratchGridItem {
  factory GiftboxScratchGridItem({
    required IngredientEntity ingredient,
    required bool isWinner,
    required bool isScratched,
  }) = _GiftboxScratchGridItem;

  factory GiftboxScratchGridItem.initial({
    IngredientEntity? ingredient,
    bool? isWinner,
    bool? isScratched,
  }) =>
      GiftboxScratchGridItem(
        ingredient: ingredient ?? IngredientEntity.empty(),
        isWinner: isWinner ?? false,
        isScratched: isScratched ?? false,
      );
}
