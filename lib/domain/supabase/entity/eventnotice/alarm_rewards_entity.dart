import 'package:fortune/data/supabase/service/service_ext.dart';

class AlarmRewardInfoEntity {
  final int id;
  final AlarmRewardType type;
  final bool hasEpicMarker;
  final bool hasRareMarker;

  AlarmRewardInfoEntity({
    required this.id,
    required this.type,
    required this.hasEpicMarker,
    required this.hasRareMarker,
  });

  factory AlarmRewardInfoEntity.empty() => AlarmRewardInfoEntity(
        id: -1,
        type: AlarmRewardType.none,
        hasEpicMarker: false,
        hasRareMarker: false,
      );
}
