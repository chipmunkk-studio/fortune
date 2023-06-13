import 'package:json_annotation/json_annotation.dart';

part 'request_mission_update.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class RequestMissionUpdate {
  @JsonKey(name: 'title')
  final String title;
  @JsonKey(name: 'subtitle')
  final String subtitle;
  @JsonKey(name: 'reward_count')
  final double rewardCount;
  @JsonKey(name: 'remain_count')
  final double remainCount;
  @JsonKey(name: 'reward_image')
  final String rewardImage;

  RequestMissionUpdate({
    required this.title,
    required this.subtitle,
    required this.rewardCount,
    required this.remainCount,
    required this.rewardImage,
  });

  factory RequestMissionUpdate.fromJson(Map<String, dynamic> json) => _$RequestMissionUpdateFromJson(json);

  Map<String, dynamic> toJson() => _$RequestMissionUpdateToJson(this);
}
