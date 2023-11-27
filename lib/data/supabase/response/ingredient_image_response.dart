import 'package:fortune/data/supabase/service_ext.dart';
import 'package:fortune/domain/supabase/entity/ingredient_image_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ingredient_image_response.g.dart';

enum IngredientImageColumn {
  imageUrl,
  type,
}

extension IngredientImageColumnExtension on IngredientImageColumn {
  String get name {
    switch (this) {
      case IngredientImageColumn.imageUrl:
        return 'image_url';
      case IngredientImageColumn.type:
        return 'type';
    }
  }
}

@JsonSerializable(ignoreUnannotated: false)
class IngredientImageResponse extends IngredientImageEntity {
  @JsonKey(name: 'image_url')
  final String? imageUrl_;
  @JsonKey(name: 'type')
  final String? type_;

  IngredientImageResponse({
    this.imageUrl_,
    this.type_,
  }) : super(
          imageUrl: imageUrl_ ?? '',
          type: getIngredientPlayType(type_),
        );

  factory IngredientImageResponse.fromJson(Map<String, dynamic> json) => _$IngredientImageResponseFromJson(json);

  Map<String, dynamic> toJson() => _$IngredientImageResponseToJson(this);
}
