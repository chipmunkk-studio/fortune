import 'package:fortune/data/supabase/service_ext.dart';
import 'package:fortune/domain/supabase/entity/eventnotice/alarm_rewards_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'alarm_reward_info_response.g.dart';

enum AlarmRewardInfoColumn {
  id,
  type,
  hasEpicMarker,
  hasRareMarker,
}

extension AlarmRewardInfoColumnExtension on AlarmRewardInfoColumn {
  String get name {
    switch (this) {
      case AlarmRewardInfoColumn.id:
        return 'id';
      case AlarmRewardInfoColumn.type:
        return 'type';
      case AlarmRewardInfoColumn.hasEpicMarker:
        return 'has_epic_marker';
      case AlarmRewardInfoColumn.hasRareMarker:
        return 'has_rare_marker';
    }
  }
}

@JsonSerializable(ignoreUnannotated: false)
class AlarmRewardInfoResponse extends AlarmRewardInfoEntity {
  @JsonKey(name: 'id')
  final double? id_;
  @JsonKey(name: 'type')
  final String? type_;
  @JsonKey(name: 'has_epic_marker')
  final bool? hasEpicMarker_;
  @JsonKey(name: 'has_rare_marker')
  final bool? hasRareMarker_;

  AlarmRewardInfoResponse({
    required this.id_,
    required this.type_,
    required this.hasEpicMarker_,
    required this.hasRareMarker_,
  }) : super(
          id: id_?.toInt() ?? -1,
          type: getEventRewardType(type_),
          hasEpicMarker: hasEpicMarker_ ?? false,
          hasRareMarker: hasRareMarker_ ?? false,
        );

  factory AlarmRewardInfoResponse.fromJson(Map<String, dynamic> json) => _$AlarmRewardInfoResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AlarmRewardInfoResponseToJson(this);
}
