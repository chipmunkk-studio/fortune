import 'package:json_annotation/json_annotation.dart';

part 'marker_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class MarkerResponse {
  @JsonKey(name: 'id')
  final String? id;
  @JsonKey(name: 'name')
  final String? name;
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  @JsonKey(name: 'item_type')
  final String? itemType;
  @JsonKey(name: 'latitude')
  final double? latitude;
  @JsonKey(name: 'longitude')
  final double? longitude;
  @JsonKey(name: 'cost')
  final int? cost;

  MarkerResponse({
    this.id,
    this.name,
    this.imageUrl,
    this.itemType,
    this.latitude,
    this.longitude,
    this.cost,
  });

  factory MarkerResponse.fromJson(Map<String, dynamic> json) => _$MarkerResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MarkerResponseToJson(this);
}
