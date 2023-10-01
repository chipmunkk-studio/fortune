import 'package:json_annotation/json_annotation.dart';

part 'request_mission_clear_user_histories.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class RequestMissionClearUserHistories {
  @JsonKey(name: 'missions')
  final int? mission;
  @JsonKey(name: 'users')
  final int? user;

  RequestMissionClearUserHistories({
    this.mission,
    this.user,
  });

  RequestMissionClearUserHistories.insert({
    required this.mission,
    required this.user,
  });

  factory RequestMissionClearUserHistories.fromJson(Map<String, dynamic> json) =>
      _$RequestMissionClearUserHistoriesFromJson(json);

  Map<String, dynamic> toJson() => _$RequestMissionClearUserHistoriesToJson(this);
}
