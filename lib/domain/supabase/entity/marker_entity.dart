import 'ingredient_entity.dart';

class MarkerEntity {
  final int id;
  final IngredientEntity ingredient;
  final double latitude;
  final double longitude;
  final int? lastObtainUser;
  final int hitCount;
  final bool isReward;

  MarkerEntity({
    required this.id,
    required this.ingredient,
    required this.latitude,
    required this.longitude,
    required this.lastObtainUser,
    required this.hitCount,
    required this.isReward,
  });

  MarkerEntity.empty()
      : id = -1,
        ingredient = IngredientEntity.empty(),
        latitude = 0.0,
        longitude = 0.0,
        lastObtainUser = null,
        isReward = false,
        hitCount = 0;
}
