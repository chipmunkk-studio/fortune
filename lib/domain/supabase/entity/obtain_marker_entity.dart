class ObtainHistoryEntity {
  final int id;
  final String nickname;
  final String ingredientImage;
  final String krIngredientName;
  final String enIngredientName;
  final String ingredientType;
  final String location;
  final String createdAt;
  final String locationKr;

  ObtainHistoryEntity({
    required this.id,
    required this.nickname,
    required this.ingredientImage,
    required this.krIngredientName,
    required this.enIngredientName,
    required this.location,
    required this.createdAt,
    required this.locationKr,
    required this.ingredientType,
  });
}
