import 'package:foresh_flutter/domain/supabase/entity/marker_entity.dart';


class EventRewardsEntity {
  final int id;
  final MarkerEntity markers;
  final int ticket;

  EventRewardsEntity({
    required this.id,
    required this.markers,
    required this.ticket,
  });

  factory EventRewardsEntity.empty() {
    return EventRewardsEntity(
      id: 0,
      markers: MarkerEntity.empty(), // Add or replace with a valid default value
      ticket: 0,
    );
  }
}
