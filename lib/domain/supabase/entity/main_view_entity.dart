import 'fortune_user_entity.dart';
import 'marker_entity.dart';
import 'obtain_history_entity.dart';
import 'user_notices_entity.dart';

class MainViewEntity {
  final FortuneUserEntity user;
  final List<MarkerEntity> markers;
  final List<ObtainHistoryContentViewItem> histories;
  final List<UserNoticesEntity> notices;
  final int haveCount;

  MainViewEntity({
    required this.user,
    required this.markers,
    required this.histories,
    required this.haveCount,
    required this.notices,
  });
}
