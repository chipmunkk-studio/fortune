import 'package:foresh_flutter/domain/supabase/entity/mission_detail_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'mission_detail_state.freezed.dart';

@freezed
class MissionDetailState with _$MissionDetailState {
  factory MissionDetailState({
    required MissionDetailEntity entity,
    required bool isLoading,
    required bool isEnableButton,
    required IngredientLayoutViewType viewType,
  }) = _MissionDetailState;

  factory MissionDetailState.initial() => MissionDetailState(
        entity: MissionDetailEntity.initial(),
        viewType: IngredientLayoutViewType.none,
        isEnableButton: false,
        isLoading: true,
      );
}

enum IngredientLayoutViewType {
  one,
  two,
  three,
  four,
  five,
  six,
  seven,
  none,
}

IngredientLayoutViewType getViewTypeByLength(int ingredientLength) {
  switch(ingredientLength) {
    case 1:
      return IngredientLayoutViewType.one;
    case 2:
      return IngredientLayoutViewType.two;
    case 3:
      return IngredientLayoutViewType.three;
    case 4:
      return IngredientLayoutViewType.four;
    case 5:
      return IngredientLayoutViewType.five;
    case 6:
      return IngredientLayoutViewType.six;
    case 7:
      return IngredientLayoutViewType.seven;
    default:
      return IngredientLayoutViewType.none;
  }
}
