import 'package:json_annotation/json_annotation.dart';

part 'request_mission_clear_user_update.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class RequestMissionClearUserUpdate {
  @JsonKey(name: 'mission')
  final int missionId;
  @JsonKey(name: 'user')
  final int userId;
  @JsonKey(name: 'email')
  final String email;
  @JsonKey(name: 'created_at')
  final String createdAt;

  RequestMissionClearUserUpdate({
    required this.createdAt,
    required this.missionId,
    required this.userId,
    required this.email,
  });

  factory RequestMissionClearUserUpdate.fromJson(Map<String, dynamic> json) =>
      _$RequestMissionClearUserUpdateFromJson(json);

  Map<String, dynamic> toJson() => _$RequestMissionClearUserUpdateToJson(this);
}
