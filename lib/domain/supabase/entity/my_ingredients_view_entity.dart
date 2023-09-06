import 'eventnotice/alarm_feeds_entity.dart';
import 'fortune_user_entity.dart';
import 'marker_entity.dart';
import 'obtain_history_entity.dart';

class MyIngredientsViewEntity {
  final List<MyIngredientsViewListEntity> histories;
  final int totalCount;

  MyIngredientsViewEntity({
    required this.histories,
    required this.totalCount,
  });

  factory MyIngredientsViewEntity.empty() => MyIngredientsViewEntity(
        histories: List.empty(),
        totalCount: 0,
      );
}

class MyIngredientsViewListEntity {
  final List<ObtainHistoryEntity> histories;

  MyIngredientsViewListEntity({
    required this.histories,
  });
}
