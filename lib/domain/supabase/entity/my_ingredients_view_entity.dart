import 'package:fortune/domain/supabase/entity/ingredient_entity.dart';

import 'obtain_history_entity.dart';

class MyIngredientsViewEntity {
  final List<MyIngredientsViewListEntity> histories;
  final int totalCount;

  MyIngredientsViewEntity({
    required this.histories,
    required this.totalCount,
  });

  factory MyIngredientsViewEntity.empty() => MyIngredientsViewEntity(
        histories: List.empty(),
        totalCount: 0,
      );
}

class MyIngredientsViewListEntity {
  final IngredientEntity ingredient;
  final List<ObtainHistoryEntity> histories;

  MyIngredientsViewListEntity({
    required this.histories,
    required this.ingredient,
  });
}
