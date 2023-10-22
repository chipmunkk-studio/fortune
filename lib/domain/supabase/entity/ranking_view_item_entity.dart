class RankingViewItemEntity {
  List<RankingPagingViewItem> rankingItems;

  RankingMyRankingViewItem myRanking;

  RankingViewItemEntity({
    required this.rankingItems,
    required this.myRanking,
  });
}

abstract class RankingPagingViewItem {}

class RankingPagingViewItemEntity extends RankingPagingViewItem {
  final String nickName;
  final String count;
  final String profile;

  RankingPagingViewItemEntity({
    required this.nickName,
    required this.count,
    required this.profile,
  });
}

class RankingPagingLoadingViewItemEntity extends RankingPagingViewItem {}

class RankingMyRankingViewItem {
  final String nickName;
  final String count;
  final String profile;

  final String index;

  RankingMyRankingViewItem({
    required this.index,
    required this.nickName,
    required this.count,
    required this.profile,
  });

  factory RankingMyRankingViewItem.empty() {
    return RankingMyRankingViewItem(
      nickName: '',
      count: '',
      profile: '',
      index: '',
    );
  }
}
