import 'package:foresh_flutter/domain/entities/common/faq_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'faq_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class FaqResponse extends FaqEntity {
  @JsonKey(name: 'faqs')
  final List<Faq>? faqs_;

  FaqResponse({this.faqs_})
      : super(
          faqs: faqs_
                  ?.map(
                    (e) => FaqContentEntity(
                      title: e.title ?? "",
                      content: e.content ?? "",
                      createdAt: e.createdAt ?? "",
                    ),
                  )
                  .toList() ??
              List.empty(),
        );

  factory FaqResponse.fromJson(Map<String, dynamic> json) => _$FaqResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FaqResponseToJson(this);
}

@JsonSerializable(ignoreUnannotated: false)
class Faq {
  @JsonKey(name: 'title')
  final String? title;
  @JsonKey(name: 'content')
  final String? content;
  @JsonKey(name: 'createdAt')
  final String? createdAt;

  Faq({
    this.title,
    this.content,
    this.createdAt,
  });

  factory Faq.fromJson(Map<String, dynamic> json) => _$FaqFromJson(json);

  Map<String, dynamic> toJson() => _$FaqToJson(this);
}
