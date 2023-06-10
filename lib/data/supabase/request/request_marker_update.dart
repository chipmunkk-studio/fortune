
import 'package:json_annotation/json_annotation.dart';

part 'request_marker_update.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class RequestMarkerUpdate {
  @JsonKey(name: 'latitude')
  final double latitude_;
  @JsonKey(name: 'longitude')
  final double longitude_;
  @JsonKey(name: 'last_obtain_user')
  final int? lastObtainUser_;

  RequestMarkerUpdate({
    required this.latitude_,
    required this.longitude_,
    required this.lastObtainUser_,
  }) : super();

  factory RequestMarkerUpdate.fromJson(Map<String, dynamic> json) => _$RequestMarkerUpdateFromJson(json);

  Map<String, dynamic> toJson() => _$RequestMarkerUpdateToJson(this);
}

