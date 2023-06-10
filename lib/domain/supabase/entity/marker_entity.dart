import 'ingredient_entity.dart';

class MarkerEntity {
  final int id;
  final IngredientEntity ingredient;
  final double latitude;
  final double longitude;
  final int? lastObtainUser;

  MarkerEntity({
    required this.id,
    required this.ingredient,
    required this.latitude,
    required this.longitude,
    required this.lastObtainUser,
  });
}
