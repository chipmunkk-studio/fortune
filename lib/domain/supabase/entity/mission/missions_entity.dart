import 'package:fortune/data/supabase/response/mission/mission_ext.dart';

import 'mission_reward_entity.dart';

class MissionsEntity {
  final int id;
  final String title;
  final String content;
  final String note;
  final String image;
  final MissionType type;
  final MissionRewardEntity reward;
  final bool isActive;

  MissionsEntity({
    required this.id,
    required this.title,
    required this.content,
    required this.note,
    required this.type,
    required this.reward,
    required this.isActive,
    required this.image,
  });

  factory MissionsEntity.empty() {
    return MissionsEntity(
      id: 0,
      title: '',
      content: '',
      note: '',
      type: MissionType.none,
      reward: MissionRewardEntity.empty(),
      image: '',
      isActive: false,
    );
  }
}
