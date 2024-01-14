import 'package:fortune/domain/supabase/entity/fortune_user_grade_entity.dart';

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
  final int level;
  final FortuneUserGradeEntity grade;

  RankingPagingViewItemEntity({
    required this.nickName,
    required this.count,
    required this.profile,
    required this.level,
    required this.grade,
  });
}

class RankingPagingLoadingViewItemEntity extends RankingPagingViewItem {}

class RankingMyRankingViewItem {
  final String nickName;
  final String count;
  final String profile;

  final String index;
  final int level;
  final FortuneUserGradeEntity grade;

  RankingMyRankingViewItem({
    required this.index,
    required this.nickName,
    required this.count,
    required this.profile,
    required this.level,
    required this.grade,
  });

  factory RankingMyRankingViewItem.empty() {
    return RankingMyRankingViewItem(
      nickName: '',
      count: '',
      profile: '',
      index: '',
      level: 0,
      grade: GradeBronze(),
    );
  }
}
