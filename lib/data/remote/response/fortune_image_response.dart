import 'package:fortune/data/remote/response/fortune_response_ext.dart';
import 'package:fortune/domain/entity/fortune_image_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'fortune_image_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class FortuneImageResponse extends FortuneImageEntity {
  @JsonKey(name: 'url')
  final String? url_;
  @JsonKey(name: 'type')
  final String? type_;
  @JsonKey(name: 'alt')
  final String? alt_;

  FortuneImageResponse({
    this.url_,
    this.type_,
    this.alt_,
  }) : super(
          url: url_ ?? '',
          type: getImageType(type_),
          alt: alt_ ?? '',
        );

  factory FortuneImageResponse.fromJson(Map<String, dynamic> json) => _$FortuneImageResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FortuneImageResponseToJson(this);
}
