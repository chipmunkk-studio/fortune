import 'package:foresh_flutter/domain/supabase/entity/my_ingredients_view_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'my_ingredients_state.freezed.dart';

@freezed
class MyIngredientsState with _$MyIngredientsState {
  factory MyIngredientsState({
    required MyIngredientsViewEntity entities,
  }) = _MyIngredientsState;

  factory MyIngredientsState.initial([
    MyIngredientsViewEntity? entities,
  ]) =>
      MyIngredientsState(
        entities: entities ?? MyIngredientsViewEntity.empty(),
      );
}
