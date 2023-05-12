import 'reward_marker_entity.dart';
import 'reward_product_entity.dart';

class RewardEntity {
  final int totalMarkerCount;
  final List<RewardMarkerEntity> markers;
  final List<RewardProductEntity> rewards;

  RewardEntity({
    required this.totalMarkerCount,
    required this.markers,
    required this.rewards,
  });
}
