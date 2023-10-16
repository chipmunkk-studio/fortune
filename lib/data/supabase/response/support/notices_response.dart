import 'package:fortune/core/util/date.dart';
import 'package:fortune/core/util/locale.dart';
import 'package:fortune/domain/supabase/entity/support/notices_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notices_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class NoticesResponse extends NoticesEntity {
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

  NoticesResponse({
    this.krTitle_,
    this.krContent_,
    this.enTitle_,
    this.enContent_,
    this.createdAt_,
  }) : super(
          title: getLocaleContent(en: enTitle_ ?? '', kr: krTitle_ ?? ''),
          content: getLocaleContent(en: enContent_ ?? '', kr: krContent_ ?? ''),
          createdAt: FortuneDateExtension.formattedDate(createdAt_),
          isNew: !FortuneDateExtension.isTwoWeeksPassed(createdAt_),
        );

  factory NoticesResponse.fromJson(Map<String, dynamic> json) => _$NoticesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$NoticesResponseToJson(this);
}
