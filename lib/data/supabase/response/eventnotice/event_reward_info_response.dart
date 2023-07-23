import 'package:foresh_flutter/data/supabase/service/service_ext.dart';
import 'package:foresh_flutter/domain/supabase/entity/eventnotice/event_rewards_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'event_reward_info_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class EventRewardInfoResponse extends EventRewardInfoEntity {
  @JsonKey(name: 'id')
  final double id_;
  @JsonKey(name: 'type')
  final String type_;
  @JsonKey(name: 'random_marker')
  final bool randomMarker_;
  @JsonKey(name: 'has_unique_marker')
  final bool hasUniqueMarker_;
  @JsonKey(name: 'marker_count')
  final int markerCount_;

  EventRewardInfoResponse({
    required this.id_,
    required this.type_,
    required this.randomMarker_,
    required this.hasUniqueMarker_,
    required this.markerCount_,
  }) : super(
          id: id_.toInt(),
          type: getEventRewardType(type_),
          randomMarker: randomMarker_,
          hasUniqueMarker: hasUniqueMarker_,
          markerCount: markerCount_,
        );

  factory EventRewardInfoResponse.fromJson(Map<String, dynamic> json) => _$EventRewardInfoResponseFromJson(json);

  Map<String, dynamic> toJson() => _$EventRewardInfoResponseToJson(this);
}
