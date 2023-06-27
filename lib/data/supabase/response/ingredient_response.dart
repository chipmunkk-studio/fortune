import 'package:foresh_flutter/data/supabase/service_ext.dart';
import 'package:foresh_flutter/domain/supabase/entity/ingredient_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ingredient_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class IngredientResponse extends IngredientEntity {
  @JsonKey(name: 'id')
  final double id_;
  @JsonKey(name: 'name')
  final String name_;
  @JsonKey(name: 'type')
  final String type_;
  @JsonKey(name: 'reward_ticket')
  final int rewardTicket_;
  @JsonKey(name: 'image_url')
  final String imageUrl_;
  @JsonKey(name: 'ad_url')
  final String? adUrl_;
  @JsonKey(name: 'is_global')
  final bool isGlobal_;
  @JsonKey(name: 'distance')
  final int distance_;

  IngredientResponse({
    required this.id_,
    required this.name_,
    required this.type_,
    required this.imageUrl_,
    required this.rewardTicket_,
    required this.adUrl_,
    required this.distance_,
    required this.isGlobal_,
  }) : super(
          id: id_.toInt(),
          name: name_,
          imageUrl: imageUrl_,
          rewardTicket: rewardTicket_,
          adUrl: adUrl_ ?? "",
          type: getIngredientType(type_),
          distance: distance_,
          isGlobal: isGlobal_,
        );

  factory IngredientResponse.fromJson(Map<String, dynamic> json) => _$IngredientResponseFromJson(json);

  Map<String, dynamic> toJson() => _$IngredientResponseToJson(this);
}
