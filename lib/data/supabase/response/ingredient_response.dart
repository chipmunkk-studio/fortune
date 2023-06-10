import 'package:foresh_flutter/data/supabase/service_ext.dart';
import 'package:foresh_flutter/domain/supabase/entity/ingredient_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ingredient_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class IngredientResponse extends IngredientEntity {
  @JsonKey(name: 'id')
  final double id_;
  @JsonKey(name: 'kr_name')
  final String krName_;
  @JsonKey(name: 'en_name')
  final String enName_;
  @JsonKey(name: 'type')
  final String type_;
  @JsonKey(name: 'reward_ticket')
  final int rewardTicket_;
  @JsonKey(name: 'image_url')
  final String imageUrl_;
  @JsonKey(name: 'ad_url')
  final String? adUrl_;
  @JsonKey(name: 'disappear_image_url')
  final String disappearImageUrl_;
  @JsonKey(name: 'is_extinct')
  final bool isExtinct_;
  @JsonKey(name: 'distance')
  final int distance_;

  IngredientResponse({
    required this.id_,
    required this.krName_,
    required this.enName_,
    required this.type_,
    required this.imageUrl_,
    required this.disappearImageUrl_,
    required this.rewardTicket_,
    required this.adUrl_,
    required this.distance_,
    required this.isExtinct_,
  }) : super(
          id: id_.toInt(),
          krName: krName_,
          enName: enName_,
          imageUrl: imageUrl_,
          disappearImage: disappearImageUrl_,
          rewardTicket: rewardTicket_,
          adUrl: adUrl_ ?? "",
          type: getIngredientType(type_),
          distance: distance_,
          isExtinct: isExtinct_,
        );

  factory IngredientResponse.fromJson(Map<String, dynamic> json) => _$IngredientResponseFromJson(json);

  Map<String, dynamic> toJson() => _$IngredientResponseToJson(this);
}
