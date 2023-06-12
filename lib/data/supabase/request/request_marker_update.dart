import 'package:json_annotation/json_annotation.dart';

part 'request_marker_update.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class RequestMarkerUpdate {
  @JsonKey(name: 'latitude')
  final double latitude;
  @JsonKey(name: 'longitude')
  final double longitude;
  @JsonKey(name: 'last_obtain_user')
  final int? lastObtainUser;
  @JsonKey(name: 'hit_count')
  final int? hitCount;

  RequestMarkerUpdate({
    required this.latitude,
    required this.longitude,
    required this.lastObtainUser,
    required this.hitCount,
  }) : super();

  factory RequestMarkerUpdate.fromJson(Map<String, dynamic> json) => _$RequestMarkerUpdateFromJson(json);

  Map<String, dynamic> toJson() => _$RequestMarkerUpdateToJson(this);
}
