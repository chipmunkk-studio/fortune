import 'package:json_annotation/json_annotation.dart';

part 'request_mission_clear_user.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class RequestMissionClearUser {
  @JsonKey(name: 'missions')
  final int? mission;
  @JsonKey(name: 'users')
  final int? user;
  @JsonKey(name: 'is_receive')
  final bool? isReceive;

  RequestMissionClearUser({
    this.mission,
    this.user,
    this.isReceive,
  });

  RequestMissionClearUser.insert({
    required this.mission,
    required this.user,
    this.isReceive = false,
  });

  factory RequestMissionClearUser.fromJson(Map<String, dynamic> json) => _$RequestMissionClearUserFromJson(json);

  Map<String, dynamic> toJson() => _$RequestMissionClearUserToJson(this);
}
