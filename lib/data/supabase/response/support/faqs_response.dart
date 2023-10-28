import 'package:fortune/core/util/date.dart';
import 'package:fortune/core/util/locale.dart';
import 'package:fortune/domain/supabase/entity/support/faq_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'faqs_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class FaqsResponse extends FaqsEntity {
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

  FaqsResponse({
    this.krTitle_,
    this.krContent_,
    this.enTitle_,
    this.enContent_,
    this.createdAt_,
  }) : super(
          title: getLocaleContent(en: enTitle_ ?? '', kr: krTitle_ ?? ''),
          content: getLocaleContent(en: enContent_ ?? '', kr: krContent_ ?? ''),
          createdAt: FortuneDateExtension.formattedDate(createdAt_),
          isNew: !FortuneDateExtension.isDaysPassed(createdAt_, passDay: 7),
        );

  factory FaqsResponse.fromJson(Map<String, dynamic> json) => _$FaqsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FaqsResponseToJson(this);
}
