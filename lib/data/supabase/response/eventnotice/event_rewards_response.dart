import 'package:foresh_flutter/data/supabase/response/marker_response.dart';
import 'package:foresh_flutter/domain/supabase/entity/eventnotice/event_rewards_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'event_rewards_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class EventRewardsResponse extends EventRewardsEntity {
  @JsonKey(name: 'id')
  final double id_;
  @JsonKey(name: 'markers')
  final MarkerResponse markers_;
  @JsonKey(name: 'ticket')
  final int ticket_;

  EventRewardsResponse({
    required this.id_,
    required this.markers_,
    required this.ticket_,
  }) : super(
          id: id_.toInt(),
          ticket: ticket_,
          markers: markers_,
        );

  factory EventRewardsResponse.fromJson(Map<String, dynamic> json) => _$EventRewardsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$EventRewardsResponseToJson(this);
}
