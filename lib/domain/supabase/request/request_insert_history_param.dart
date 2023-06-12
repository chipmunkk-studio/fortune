class RequestInsertHistoryParam {
  final int ingredientId;
  final int userId;
  final String markerId;
  final String krLocationName;
  final String enLocationName;
  final String krIngredientName;
  final String enIngredientName;
  final String nickname;

  RequestInsertHistoryParam({
    required this.ingredientId,
    required this.userId,
    required this.markerId,
    required this.krLocationName,
    required this.enLocationName,
    required this.krIngredientName,
    required this.enIngredientName,
    required this.nickname,
  });
}
