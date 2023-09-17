import 'package:fortune/data/supabase/service/service_ext.dart';

class AlarmRewardInfoEntity {
  final int id;
  final AlarmRewardType type;
  final bool hasUniqueMarker;

  AlarmRewardInfoEntity({
    required this.id,
    required this.type,
    required this.hasUniqueMarker,
  });

  factory AlarmRewardInfoEntity.empty() => AlarmRewardInfoEntity(
        id: -1,
        type: AlarmRewardType.none,
        hasUniqueMarker: false,
      );
}
