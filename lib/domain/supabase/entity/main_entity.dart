import 'fortune_user_entity.dart';
import 'marker_entity.dart';
import 'obtain_marker_entity.dart';

class MainEntity {
  final FortuneUserEntity user;
  final List<MarkerEntity> markers;
  final List<ObtainHistoryEntity> histories;

  MainEntity({
    required this.user,
    required this.markers,
    required this.histories,
  });
}
