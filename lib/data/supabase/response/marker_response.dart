import 'package:fortune/domain/supabase/entity/marker_entity.dart';
import 'package:json_annotation/json_annotation.dart';

import 'ingredient_response.dart';

part 'marker_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class MarkerResponse extends MarkerEntity {
  @JsonKey(name: 'id')
  final double id_;
  @JsonKey(name: 'ingredients')
  final IngredientResponse ingredient_;
  @JsonKey(name: 'latitude')
  final double latitude_;
  @JsonKey(name: 'longitude')
  final double longitude_;
  @JsonKey(name: 'hit_count')
  final int hitCount_;
  @JsonKey(name: 'last_obtain_user')
  final int? lastObtainUser_;

  MarkerResponse({
    required this.id_,
    required this.ingredient_,
    required this.latitude_,
    required this.hitCount_,
    required this.longitude_,
    required this.lastObtainUser_,
  }) : super(
          id: id_.toInt(),
          ingredient: ingredient_,
          hitCount: hitCount_.toInt(),
          latitude: latitude_,
          longitude: longitude_,
          lastObtainUser: lastObtainUser_,
        );

  factory MarkerResponse.fromJson(Map<String, dynamic> json) => _$MarkerResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MarkerResponseToJson(this);
}
