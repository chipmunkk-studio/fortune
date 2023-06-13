import 'package:json_annotation/json_annotation.dart';

part 'request_mission_update.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class RequestMissionUpdate {
  @JsonKey(name: 'remain_count')
  final int remainCount;

  RequestMissionUpdate({
    required this.remainCount,
  });

  factory RequestMissionUpdate.fromJson(Map<String, dynamic> json) => _$RequestMissionUpdateFromJson(json);

  Map<String, dynamic> toJson() => _$RequestMissionUpdateToJson(this);
}
