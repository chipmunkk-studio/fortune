import 'package:fortune/domain/entity/scratch_cover_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'scratch_cover_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class ScratchCoverResponse extends ScratchCoverEntity {
  @JsonKey(name: 'title')
  final String? title_;
  @JsonKey(name: 'description')
  final String? description_;
  @JsonKey(name: 'image_url')
  final String? imageUrl_;

  ScratchCoverResponse({
    this.title_,
    this.description_,
    this.imageUrl_,
  }) : super(
          title: title_ ?? '',
          description: description_ ?? '',
          imageUrl: imageUrl_ ?? '',
        );

  factory ScratchCoverResponse.fromJson(Map<String, dynamic> json) => _$ScratchCoverResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ScratchCoverResponseToJson(this);
}
