import 'package:foresh_flutter/data/supabase/response/mission/mission_ext.dart';
import 'package:foresh_flutter/domain/supabase/entity/marker_entity.dart';

import 'mission_reward_entity.dart';

class MissionsEntity {
  final int id;
  final String title;
  final String content;
  final MissionType missionType;
  final MissionRewardEntity missionReward;
  final MarkerEntity marker;
  final bool isGlobal;
  final bool isActive;

  MissionsEntity({
    required this.id,
    required this.title,
    required this.content,
    required this.missionType,
    required this.missionReward,
    required this.marker,
    required this.isGlobal,
    required this.isActive,
  });

  factory MissionsEntity.empty() {
    return MissionsEntity(
      id: 0,
      title: '',
      content: '',
      missionType: MissionType.none,
      missionReward: MissionRewardEntity.empty(),
      marker: MarkerEntity.empty(),
      isGlobal: false,
      isActive: false,
    );
  }
}
