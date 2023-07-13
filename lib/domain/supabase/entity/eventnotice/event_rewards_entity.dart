import 'package:foresh_flutter/data/supabase/service/service_ext.dart';


class EventRewardsEntity {
  final int id;
  final EventRewardType type;
  final int ticket;

  EventRewardsEntity({
    required this.id,
    required this.type,
    required this.ticket,
  });

  factory EventRewardsEntity.empty() {
    return EventRewardsEntity(
      id: 0,
      type: EventRewardType.none, // Add or replace with a valid default value
      ticket: 0,
    );
  }
}
