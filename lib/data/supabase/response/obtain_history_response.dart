import 'package:foresh_flutter/domain/supabase/entity/obtain_marker_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'obtain_history_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class ObtainHistoryResponse extends ObtainHistoryEntity {
  @JsonKey(name: 'id')
  final double id_;
  @JsonKey(name: 'nickname')
  final String nickname_;
  @JsonKey(name: 'ingredient_image')
  final String ingredientImage_;
  @JsonKey(name: 'kr_ingredient_name')
  final String krIngredientName_;
  @JsonKey(name: 'en_ingredient_name')
  final String enIngredientName_;
  @JsonKey(name: 'ingredient_type')
  final String ingredientType_;
  @JsonKey(name: 'location')
  final String location_;
  @JsonKey(name: 'location_kr')
  final String locationKr_;
  @JsonKey(name: 'created_at')
  final String createdAt_;

  ObtainHistoryResponse({
    required this.id_,
    required this.nickname_,
    required this.ingredientImage_,
    required this.krIngredientName_,
    required this.enIngredientName_,
    required this.location_,
    required this.createdAt_,
    required this.locationKr_,
    required this.ingredientType_,
  }) : super(
          id: id_.toInt(),
          ingredientImage: ingredientImage_,
          krIngredientName: krIngredientName_,
          enIngredientName: enIngredientName_,
          ingredientType: ingredientType_,
          nickname: nickname_,
          location: location_,
          createdAt: createdAt_,
          locationKr: locationKr_,
        );

  factory ObtainHistoryResponse.fromJson(Map<String, dynamic> json) => _$ObtainHistoryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ObtainHistoryResponseToJson(this);
}
