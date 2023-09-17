import 'package:fortune/data/supabase/service/service_ext.dart';
import 'package:fortune/domain/supabase/entity/eventnotice/alarm_rewards_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'alarm_reward_info_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class AlarmRewardInfoResponse extends AlarmRewardInfoEntity {
  @JsonKey(name: 'id')
  final double id_;
  @JsonKey(name: 'type')
  final String type_;
  @JsonKey(name: 'has_unique_marker')
  final bool hasUniqueMarker_;

  AlarmRewardInfoResponse({
    required this.id_,
    required this.type_,
    required this.hasUniqueMarker_,
  }) : super(
          id: id_.toInt(),
          type: getEventRewardType(type_),
          hasUniqueMarker: hasUniqueMarker_,
        );

  factory AlarmRewardInfoResponse.fromJson(Map<String, dynamic> json) => _$AlarmRewardInfoResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AlarmRewardInfoResponseToJson(this);
}
