import 'package:foresh_flutter/domain/supabase/entity/common/faq_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'faqs_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class FaqsResponse extends FaqsEntity {
  @JsonKey(name: 'title')
  final String? title_;
  @JsonKey(name: 'content')
  final String? content_;
  @JsonKey(name: 'created_at')
  final String? createdAt_;

  FaqsResponse({
    this.title_,
    this.content_,
    this.createdAt_,
  }) : super(
          title: title_ ?? '',
          content: content_ ?? '',
          createdAt: createdAt_ ?? '',
        );

  factory FaqsResponse.fromJson(Map<String, dynamic> json) => _$FaqsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FaqsResponseToJson(this);
}
