import 'package:foresh_flutter/domain/supabase/entity/common/notices_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notices_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class NoticesResponse extends NoticesEntity {
  @JsonKey(name: 'title')
  final String? title_;
  @JsonKey(name: 'content')
  final String? content_;
  @JsonKey(name: 'created_at')
  final String? createdAt_;

  NoticesResponse({
    this.title_,
    this.content_,
    this.createdAt_,
  }) : super(
          title: title_ ?? '',
          content: content_ ?? '',
          createdAt: createdAt_ ?? '',
        );

  factory NoticesResponse.fromJson(Map<String, dynamic> json) => _$NoticesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$NoticesResponseToJson(this);
}
