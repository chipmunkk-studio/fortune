import 'package:json_annotation/json_annotation.dart'; 

part 'request_post_marker.g.dart'; 

@JsonSerializable(nullable: true, ignoreUnannotated: false)
class RequestPostMarker {
  @JsonKey(name: 'id')
  int id;
  @JsonKey(name: 'latitude')
  double latitude;
  @JsonKey(name: 'longitude')
  double longitude;

  RequestPostMarker({required this.id, required this.latitude, required this.longitude});

   factory RequestPostMarker.fromJson(Map<String, dynamic> json) => _$RequestPostMarkerFromJson(json);

   Map<String, dynamic> toJson() => _$RequestPostMarkerToJson(this);
}

