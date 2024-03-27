import 'package:json_annotation/json_annotation.dart';

part 'request_mission_acquire.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class RequestMissionAcquire {
  @JsonKey(name: 'id')
  final String? id;
  @JsonKey(name: 'ts')
  final int? ts;

  RequestMissionAcquire({this.id, this.ts});

  factory RequestMissionAcquire.fromJson(Map<String, dynamic> json) => _$RequestMissionAcquireFromJson(json);

  Map<String, dynamic> toJson() => _$RequestMissionAcquireToJson(this);
}
