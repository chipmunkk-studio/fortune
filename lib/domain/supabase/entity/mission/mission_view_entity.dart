import 'package:fortune/domain/supabase/entity/marker_entity.dart';

import 'missions_entity.dart';

class MissionEntity {
  final MissionsEntity mission;
  final MarkerEntity relayMarker;
  final int userHaveCount;
  final int requiredTotalCount;
  final int satisfiedCount;
  final int totalConditionSize;
  final bool isRelayMissionCleared;

  MissionEntity({
    required this.mission,
    required this.relayMarker,
    required this.userHaveCount,
    required this.requiredTotalCount,
    required this.satisfiedCount,
    required this.totalConditionSize,
  }) : isRelayMissionCleared = !relayMarker.isEmpty && satisfiedCount >= totalConditionSize;
}
