import 'ingredient_entity.dart';

class MarkerEntity {
  final int id;
  final IngredientEntity ingredient;
  final double latitude;
  final double longitude;
  final int? lastObtainUser;
  final int hitCount;

  MarkerEntity({
    required this.id,
    required this.ingredient,
    required this.latitude,
    required this.longitude,
    required this.lastObtainUser,
    required this.hitCount,
  });

  MarkerEntity.empty()
      : id = 0,
        ingredient = IngredientEntity.empty(),
        latitude = 0.0,
        longitude = 0.0,
        lastObtainUser = null,
        hitCount = 0;
}
