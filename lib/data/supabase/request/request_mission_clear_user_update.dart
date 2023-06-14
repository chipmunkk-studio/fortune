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
  @JsonKey(name: 'is_receive')
  final bool isReceived;

  RequestMissionClearUserUpdate({
    required this.missionId,
    required this.userId,
    required this.email,
    required this.isReceived,
  });

  factory RequestMissionClearUserUpdate.fromJson(Map<String, dynamic> json) =>
      _$RequestMissionClearUserUpdateFromJson(json);

  Map<String, dynamic> toJson() => _$RequestMissionClearUserUpdateToJson(this);
}
