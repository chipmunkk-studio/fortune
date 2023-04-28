import 'package:json_annotation/json_annotation.dart';

part 'main_marker_response.g.dart';

@JsonSerializable(nullable: true, ignoreUnannotated: false)
class MainMarkerResponse {
  @JsonKey(name: 'latitude')
  double latitude;
  @JsonKey(name: 'longitude')
  double longitude;
  @JsonKey(name: 'grade')
  int grade;
  @JsonKey(name: 'id')
  int id;
  @JsonKey(name: 'createdAt')
  String createdAt;
  @JsonKey(name: 'modifiedAt')
  String modifiedAt;

  MainMarkerResponse({
    required this.latitude,
    required this.longitude,
    required this.grade,
    required this.id,
    required this.createdAt,
    required this.modifiedAt,
  });

  factory MainMarkerResponse.fromJson(Map<String, dynamic> json) => _$MainMarkerResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MainMarkerResponseToJson(this);
}
