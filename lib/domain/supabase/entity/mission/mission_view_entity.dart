
import 'package:foresh_flutter/domain/supabase/entity/marker_entity.dart';

import 'missions_entity.dart';

class MissionViewEntity {
  final MissionsEntity mission;
  final MarkerEntity relayMarker;
  final int userHaveCount;
  final int requiredTotalCount;

  MissionViewEntity({
    required this.mission,
    required this.relayMarker,
    required this.userHaveCount,
    required this.requiredTotalCount,
  });
}
