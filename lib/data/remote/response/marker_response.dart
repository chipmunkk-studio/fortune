import 'package:fortune/domain/entity/marker_entity.dart';
import 'package:json_annotation/json_annotation.dart';

import 'fortune_image_response.dart';

part 'marker_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class MarkerResponse {
  @JsonKey(name: 'id')
  final String? id_;
  @JsonKey(name: 'name')
  final String? name_;
  @JsonKey(name: 'image')
  final FortuneImageResponse? image_;
  @JsonKey(name: 'item_type')
  final String? itemType_;
  @JsonKey(name: 'latitude')
  final double? latitude_;
  @JsonKey(name: 'longitude')
  final double? longitude_;
  @JsonKey(name: 'cost')
  final int? cost_;

  MarkerResponse({
    this.id_,
    this.name_,
    this.image_,
    this.itemType_,
    this.latitude_,
    this.longitude_,
    this.cost_,
  });

  factory MarkerResponse.fromJson(Map<String, dynamic> json) => _$MarkerResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MarkerResponseToJson(this);
}
