import 'package:fortune/core/util/date.dart';
import 'package:fortune/core/util/locale.dart';
import 'package:fortune/domain/supabase/entity/support/privacy_policy_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'privacy_policy_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class PrivacyPolicyResponse extends PrivacyPolicyEntity {
  @JsonKey(name: 'kr_title')
  final String? krTitle_;
  @JsonKey(name: 'kr_content')
  final String? krContent_;
  @JsonKey(name: 'en_title')
  final String? enTitle_;
  @JsonKey(name: 'en_content')
  final String? enContent_;
  @JsonKey(name: 'created_at')
  final String? createdAt_;

  PrivacyPolicyResponse({
    this.krTitle_,
    this.krContent_,
    this.enTitle_,
    this.enContent_,
    this.createdAt_,
  }) : super(
          title: getLocaleContent(en: enTitle_ ?? '', kr: krTitle_ ?? ''),
          content: getLocaleContent(en: enContent_ ?? '', kr: krContent_ ?? ''),
          createdAt: FortuneDateExtension.formattedDate(createdAt_),
        );

  factory PrivacyPolicyResponse.fromJson(Map<String, dynamic> json) => _$PrivacyPolicyResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PrivacyPolicyResponseToJson(this);
}
