import 'package:foresh_flutter/data/supabase/response/mission/mission_ext.dart';
import 'package:foresh_flutter/data/supabase/response/mission/mission_reward_response.dart';
import 'package:foresh_flutter/domain/supabase/entity/mission/mission_reward_entity.dart';
import 'package:foresh_flutter/domain/supabase/entity/mission/missions_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'missions_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class MissionsResponse extends MissionsEntity {
  @JsonKey(name: 'id')
  final double id_;
  @JsonKey(name: 'title')
  final String title_;
  @JsonKey(name: 'content')
  final String content_;
  @JsonKey(name: 'mission_type')
  final String missionType_;
  @JsonKey(name: 'mission_reward')
  final MissionRewardResponse? missionReward_;
  @JsonKey(name: 'is_global')
  final bool isGlobal_;
  @JsonKey(name: 'is_active')
  final bool isActive_;

  MissionsResponse({
    required this.id_,
    required this.title_,
    required this.content_,
    required this.missionType_,
    required this.missionReward_,
    required this.isGlobal_,
    required this.isActive_,
  }) : super(
          id: id_.toInt(),
          title: title_,
          content: content_,
          missionType: getMissionType(missionType_),
          missionReward: missionReward_ ?? MissionRewardEntity.empty(),
          isGlobal: isGlobal_,
          isActive: isActive_,
        );

  factory MissionsResponse.fromJson(Map<String, dynamic> json) => _$MissionsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MissionsResponseToJson(this);
}
