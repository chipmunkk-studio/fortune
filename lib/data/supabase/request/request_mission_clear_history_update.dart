import 'package:json_annotation/json_annotation.dart';

part 'request_mission_clear_history_update.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class RequestMissionClearHistoryUpdate {
  @JsonKey(name: 'title')
  final String title;
  @JsonKey(name: 'subtitle')
  final String subtitle;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'reward_image')
  final String rewardImage;
  @JsonKey(name: 'nickname')
  final String nickname;

  RequestMissionClearHistoryUpdate({
    required this.title,
    required this.subtitle,
    required this.createdAt,
    required this.rewardImage,
    required this.nickname,
  });

  factory RequestMissionClearHistoryUpdate.fromJson(Map<String, dynamic> json) =>
      _$RequestMissionClearHistoryUpdateFromJson(json);

  Map<String, dynamic> toJson() => _$RequestMissionClearHistoryUpdateToJson(this);
}
