import 'package:fortune/domain/supabase/entity/mission/mission_clear_user_histories_entity.dart';

import 'fortune_user_entity.dart';
import 'marker_entity.dart';

class MainViewEntity {
  final FortuneUserEntity user;
  final List<MarkerEntity> markers;
  final List<MissionClearUserHistoriesEntity> missionClearUsers;
  final int haveCount;
  final bool hasNewAlarm;

  MainViewEntity({
    required this.user,
    required this.markers,
    required this.missionClearUsers,
    required this.haveCount,
    required this.hasNewAlarm,
  });
}
