import 'package:fortune/core/util/locale.dart';
import 'package:fortune/domain/supabase/entity/agree_terms_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'agree_terms_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class AgreeTermsResponse extends AgreeTermsEntity {
  @JsonKey(name: 'index')
  final int? index_;
  @JsonKey(name: 'is_require')
  final bool? isRequire_;
  @JsonKey(name: 'kr_title')
  final String? krTitle_;
  @JsonKey(name: 'kr_content')
  final String? krContent_;
  @JsonKey(name: 'en_title')
  final String? enTitle_;
  @JsonKey(name: 'en_content')
  final String? enContent_;

  AgreeTermsResponse({
    this.index_,
    this.isRequire_,
    this.krTitle_,
    this.krContent_,
    this.enTitle_,
    this.enContent_,
  }) : super(
          index: index_ ?? -1,
          isRequire: isRequire_ ?? true,
          title: getLocaleContent(en: enTitle_ ?? '', kr: krTitle_ ?? ''),
          content: getLocaleContent(en: enContent_ ?? '', kr: krContent_ ?? ''),
        );

  factory AgreeTermsResponse.fromJson(Map<String, dynamic> json) => _$AgreeTermsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AgreeTermsResponseToJson(this);
}
