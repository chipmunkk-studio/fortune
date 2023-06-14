import 'package:json_annotation/json_annotation.dart';

part 'request_mission_clear_history_update.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class RequestMissionClearHistoryUpdate {
  @JsonKey(name: 'user_id')
  final int userId;
  @JsonKey(name: 'title')
  final String title;
  @JsonKey(name: 'subtitle')
  final String subtitle;
  @JsonKey(name: 'reward_image')
  final String rewardImage;

  RequestMissionClearHistoryUpdate({
    required this.title,
    required this.userId,
    required this.subtitle,
    required this.rewardImage,
  });

  factory RequestMissionClearHistoryUpdate.fromJson(Map<String, dynamic> json) =>
      _$RequestMissionClearHistoryUpdateFromJson(json);

  Map<String, dynamic> toJson() => _$RequestMissionClearHistoryUpdateToJson(this);
}
