import 'package:json_annotation/json_annotation.dart';

part 'scratch_cover_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class ScratchCoverResponse {
  @JsonKey(name: 'title')
  final String? title;
  @JsonKey(name: 'description')
  final String? description;
  @JsonKey(name: 'image_url')
  final String? imageUrl;

  ScratchCoverResponse({
    this.title,
    this.description,
    this.imageUrl,
  });

  factory ScratchCoverResponse.fromJson(Map<String, dynamic> json) => _$ScratchCoverResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ScratchCoverResponseToJson(this);
}
