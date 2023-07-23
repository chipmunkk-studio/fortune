import 'package:foresh_flutter/data/supabase/service/service_ext.dart';
import 'package:foresh_flutter/domain/supabase/entity/eventnotice/event_rewards_entity.dart';
import 'package:json_annotation/json_annotation.dart';

class EventRewardInfoEntity {
  final int id;
  final EventRewardType type;
  final bool randomMarker;
  final bool hasUniqueMarker;
  final int markerCount;

  EventRewardInfoEntity({
    required this.id,
    required this.type,
    required this.randomMarker,
    required this.hasUniqueMarker,
    required this.markerCount,
  });

  factory EventRewardInfoEntity.empty() => EventRewardInfoEntity(
        id: -1,
        type: EventRewardType.none,
        randomMarker: false,
        hasUniqueMarker: false,
        markerCount: 0,
      );
}
