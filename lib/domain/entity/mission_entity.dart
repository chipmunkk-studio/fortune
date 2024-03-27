import 'fortune_image_entity.dart';
import 'mission_guide_entity.dart';
import 'mission_marker_entity.dart';
import 'reward_info_entity.dart';

class MissionEntity {
  final String id;
  final String title;
  final String description;
  final FortuneImageEntity image;
  final String startAt;
  final String endAt;
  final int totalRewardCount;
  final int remainRewardCount;
  final int totalItemCount;
  final int obtainedItemCount;
  final List<MissionMarkerEntity> items;
  final MissionGuideEntity guide;
  final RewardInfoEntity rewardInfo;
  final bool isScheduled;

  MissionEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.startAt,
    required this.endAt,
    required this.totalRewardCount,
    required this.remainRewardCount,
    required this.totalItemCount,
    required this.obtainedItemCount,
    required this.items,
    required this.guide,
    required this.rewardInfo,
    required this.isScheduled,
  });

  factory MissionEntity.empty() {
    return MissionEntity(
      id: '',
      title: '',
      description: '',
      image: FortuneImageEntity.empty(),
      startAt: '',
      endAt: '',
      totalRewardCount: 0,
      remainRewardCount: 0,
      totalItemCount: 0,
      obtainedItemCount: 0,
      items: [],
      guide: MissionGuideEntity.empty(),
      rewardInfo: RewardInfoEntity.empty(),
      isScheduled: false,
    );
  }
}
