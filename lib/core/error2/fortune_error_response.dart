import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'fortune_error_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class FortuneErrorResponse {
  @JsonKey(name: 'code')
  int? code;
  @JsonKey(name: 'message')
  String? message;

  FortuneErrorResponse({
    @required this.code,
    @required this.message,
  });

  factory FortuneErrorResponse.fromJson(Map<String, dynamic> json) => _$FortuneErrorResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FortuneErrorResponseToJson(this);
}
