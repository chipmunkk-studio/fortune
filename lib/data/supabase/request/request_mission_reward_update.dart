import 'package:json_annotation/json_annotation.dart';

part 'request_mission_reward_update.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class RequestMissionRewardUpdate {
  @JsonKey(name: 'total_count')
  final int? totalCount;
  @JsonKey(name: 'remain_count')
  final int? remainCount;
  @JsonKey(name: 'reward_image')
  final String? rewardImage;

  RequestMissionRewardUpdate({
    this.totalCount,
    this.remainCount,
    this.rewardImage,
  });

  factory RequestMissionRewardUpdate.fromJson(Map<String, dynamic> json) => _$RequestMissionRewardUpdateFromJson(json);

  Map<String, dynamic> toJson() => _$RequestMissionRewardUpdateToJson(this);
}
