import 'package:fortune/domain/entity/mission_guide_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'mission_guide_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class MissionGuideResponse extends MissionGuideEntity {
  @JsonKey(name: 'mission')
  final String? mission_;
  @JsonKey(name: 'reward')
  final String? reward_;
  @JsonKey(name: 'caution')
  final String? caution_;

  MissionGuideResponse({
    this.mission_,
    this.reward_,
    this.caution_,
  }) : super(
          mission: mission_ ?? '',
          reward: reward_ ?? '',
          caution: caution_ ?? '',
        );

  factory MissionGuideResponse.fromJson(Map<String, dynamic> json) => _$MissionGuideResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MissionGuideResponseToJson(this);
}
