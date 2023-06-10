
import 'fortune_user_entity.dart';
import 'marker_entity.dart';

class MainEntity {
  final FortuneUserEntity user;
  final List<MarkerEntity> markers;

  MainEntity({
    required this.user,
    required this.markers,
  });
}
