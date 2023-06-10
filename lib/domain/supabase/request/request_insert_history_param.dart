class RequestInsertHistoryParam {
  final String nickName;
  final String krIngredientName;
  final String enIngredientName;
  final String ingredientImage;
  final String ingredientType;
  final String location;
  final String locationKr;

  RequestInsertHistoryParam({
    required this.nickName,
    required this.krIngredientName,
    required this.enIngredientName,
    required this.ingredientImage,
    required this.location,
    required this.locationKr,
    required this.ingredientType,
  });
}
