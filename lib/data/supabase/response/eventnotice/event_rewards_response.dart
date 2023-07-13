import 'package:foresh_flutter/data/supabase/service/service_ext.dart';
import 'package:foresh_flutter/domain/supabase/entity/eventnotice/event_rewards_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'event_rewards_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class EventRewardsResponse extends EventRewardsEntity {
  @JsonKey(name: 'id')
  final double id_;
  @JsonKey(name: 'type')
  final String type_;
  @JsonKey(name: 'ticket')
  final int ticket_;

  EventRewardsResponse({
    required this.id_,
    required this.type_,
    required this.ticket_,
  }) : super(
          id: id_.toInt(),
          ticket: ticket_,
          type: getEventRewardType(type_),
        );

  factory EventRewardsResponse.fromJson(Map<String, dynamic> json) => _$EventRewardsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$EventRewardsResponseToJson(this);
}
