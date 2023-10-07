import 'package:fortune/data/supabase/response/mission/mission_ext.dart';

import 'mission_reward_entity.dart';

class MissionsEntity {
  final int id;
  final String title;
  final String content;
  final String note;
  final String missionImage;
  final MissionType missionType;
  final MissionRewardEntity missionReward;
  final bool isActive;

  MissionsEntity({
    required this.id,
    required this.title,
    required this.content,
    required this.note,
    required this.missionType,
    required this.missionReward,
    required this.isActive,
    required this.missionImage,
  });

  factory MissionsEntity.empty() {
    return MissionsEntity(
      id: 0,
      title: '',
      content: '',
      note: '',
      missionType: MissionType.none,
      missionReward: MissionRewardEntity.empty(),
      missionImage: '',
      isActive: false,
    );
  }
}
