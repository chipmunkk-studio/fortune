class RequestRankingParam {
  final int start;
  final int end;

  final RankingFilterType type;

  RequestRankingParam({
    required this.start,
    required this.end,
    required this.type,
  });
}

enum RankingFilterType {
  user,
  missionClear,
}
