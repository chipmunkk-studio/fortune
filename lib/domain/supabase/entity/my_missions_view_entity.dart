import 'package:fortune/domain/supabase/entity/mission/mission_clear_user_histories_entity.dart';

import 'fortune_user_entity.dart';
import 'marker_entity.dart';

class MainViewEntity {
  final List<MissionClearUserHistoriesEntity> missions;

  MainViewEntity({
    required this.missions,
  });
}
