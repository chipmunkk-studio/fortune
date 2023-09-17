import 'package:fortune/domain/supabase/entity/agree_terms_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'agree_terms_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class AgreeTermsResponse extends AgreeTermsEntity {
  @JsonKey(name: 'index')
  final int? index_;
  @JsonKey(name: 'is_require')
  final bool? isRequire_;
  @JsonKey(name: 'title')
  final String? title_;
  @JsonKey(name: 'content')
  final String? content_;

  AgreeTermsResponse({
    this.index_,
    this.isRequire_,
    this.title_,
    this.content_,
  }) : super(
          index: index_ ?? -1,
          isRequire: isRequire_ ?? true,
          title: title_ ?? "",
          content: content_ ?? "",
        );

  factory AgreeTermsResponse.fromJson(Map<String, dynamic> json) => _$AgreeTermsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AgreeTermsResponseToJson(this);
}
