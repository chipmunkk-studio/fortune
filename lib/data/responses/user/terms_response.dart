import 'package:foresh_flutter/domain/entities/user/terms_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'terms_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class TermsResponse extends TermsEntity {
  @JsonKey(name: 'termDtos')
  final List<TermDto>? termDtos;

  TermsResponse({this.termDtos})
      : super(
          terms: termDtos
                  ?.map(
                    (e) => Term(
                      title: e.title ?? "",
                      content: e.content ?? "",
                    ),
                  )
                  .toList() ??
              List.empty(),
        );

  factory TermsResponse.fromJson(Map<String, dynamic> json) => _$TermsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TermsResponseToJson(this);
}

@JsonSerializable(ignoreUnannotated: false)
class TermDto {
  @JsonKey(name: 'title')
  final String? title;
  @JsonKey(name: 'content')
  final String? content;

  TermDto({this.title, this.content});

  factory TermDto.fromJson(Map<String, dynamic> json) => _$TermDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TermDtoToJson(this);
}
