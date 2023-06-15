class RequestInsertHistoryParam {
  final int ingredientId;
  final int userId;
  final String markerId;
  final String krLocationName;
  final String enLocationName;
  final String ingredientName;
  final String nickname;

  RequestInsertHistoryParam({
    required this.ingredientId,
    required this.userId,
    required this.markerId,
    required this.krLocationName,
    required this.enLocationName,
    required this.ingredientName,
    required this.nickname,
  });
}
