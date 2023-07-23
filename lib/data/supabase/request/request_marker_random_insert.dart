import 'package:json_annotation/json_annotation.dart';

part 'request_marker_random_insert.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class RequestMarkerRandomInsert {
  @JsonKey(name: 'ingredients')
  final int ingredient;
  @JsonKey(name: 'latitude')
  final double latitude;
  @JsonKey(name: 'longitude')
  final double longitude;

  RequestMarkerRandomInsert({
    required this.ingredient,
    required this.latitude,
    required this.longitude,
  });

  factory RequestMarkerRandomInsert.fromJson(Map<String, dynamic> json) => _$RequestMarkerRandomInsertFromJson(json);

  Map<String, dynamic> toJson() => _$RequestMarkerRandomInsertToJson(this);
}
