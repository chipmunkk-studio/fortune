import 'package:fortune/core/util/locale.dart';
import 'package:fortune/data/supabase/service_ext.dart';
import 'package:fortune/domain/supabase/entity/ingredient_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ingredient_response.g.dart';

enum IngredientColumn {
  id,
  krName,
  enName,
  type,
  rewardTicket,
  imageUrl,
  distance,
}

extension IngredientColumnExtension on IngredientColumn {
  String get name {
    switch (this) {
      case IngredientColumn.id:
        return 'id';
      case IngredientColumn.krName:
        return 'kr_name';
      case IngredientColumn.enName:
        return 'en_name';
      case IngredientColumn.type:
        return 'type';
      case IngredientColumn.rewardTicket:
        return 'reward_ticket';
      case IngredientColumn.imageUrl:
        return 'image_url';
      case IngredientColumn.distance:
        return 'distance';
    }
  }
}

@JsonSerializable(ignoreUnannotated: false)
class IngredientResponse extends IngredientEntity {
  @JsonKey(name: 'id')
  final double? id_;
  @JsonKey(name: 'kr_name')
  final String? krName_;
  @JsonKey(name: 'en_name')
  final String? enName_;
  @JsonKey(name: 'type')
  final String? type_;
  @JsonKey(name: 'reward_ticket')
  final int? rewardTicket_;
  @JsonKey(name: 'image_url')
  final String? imageUrl_;
  @JsonKey(name: 'distance')
  final int? distance_;

  IngredientResponse({
    required this.id_,
    required this.krName_,
    required this.enName_,
    required this.type_,
    required this.imageUrl_,
    required this.rewardTicket_,
    required this.distance_,
  }) : super(
          id: id_?.toInt() ?? -1,
          exposureName: getLocaleContent(en: enName_ ?? '', kr: krName_ ?? ''),
          krName: krName_ ?? '',
          enName: enName_ ?? '',
          imageUrl: imageUrl_ ?? '',
          rewardTicket: rewardTicket_ ?? 0,
          type: getIngredientType(type_),
          distance: distance_ ?? 500,
        );

  factory IngredientResponse.fromJson(Map<String, dynamic> json) => _$IngredientResponseFromJson(json);

  Map<String, dynamic> toJson() => _$IngredientResponseToJson(this);
}
