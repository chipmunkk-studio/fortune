import 'package:fortune/domain/entity/picked_item_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'picked_item_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class PickedItemResponse extends PickedItemEntity {
  @JsonKey(name: 'image_url')
  final String? imageUrl_;

  @JsonKey(name: 'name')
  final String? name_;

  @JsonKey(name: 'description')
  final String? description_;

  PickedItemResponse({
    this.imageUrl_,
    this.name_,
    this.description_,
  }) : super(
          imageUrl: imageUrl_ ?? '',
          name: name_ ?? '',
          description: description_ ?? '',
        );

  factory PickedItemResponse.fromJson(Map<String, dynamic> json) => _$PickedItemResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PickedItemResponseToJson(this);
}
