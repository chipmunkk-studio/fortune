import 'package:foresh_flutter/data/supabase/service/service_ext.dart';

class EventRewardInfoEntity {
  final int id;
  final EventRewardType type;
  final bool hasUniqueMarker;

  EventRewardInfoEntity({
    required this.id,
    required this.type,
    required this.hasUniqueMarker,
  });

  factory EventRewardInfoEntity.empty() => EventRewardInfoEntity(
        id: -1,
        type: EventRewardType.none,
        hasUniqueMarker: false,
      );
}
