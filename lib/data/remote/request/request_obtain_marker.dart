import 'package:json_annotation/json_annotation.dart';

part 'request_obtain_marker.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class RequestObtainMarker {
  @JsonKey(name: 'id')
  final String? id;
  @JsonKey(name: 'ts')
  final int? ts;

  RequestObtainMarker({this.id, this.ts});

  factory RequestObtainMarker.fromJson(Map<String, dynamic> json) => _$RequestObtainMarkerFromJson(json);

  Map<String, dynamic> toJson() => _$RequestObtainMarkerToJson(this);
}
