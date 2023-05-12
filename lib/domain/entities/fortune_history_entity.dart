class FortuneUsageHistoryEntity {
  final String date;
  final List<FortuneUsageHistoryItemEntity> items;

  FortuneUsageHistoryEntity({
    required this.date,
    required this.items,
  });
}

class FortuneUsageHistoryItemEntity {
  String content;
  String time;

  FortuneUsageHistoryItemEntity({
    required this.content,
    required this.time,
  });
}
