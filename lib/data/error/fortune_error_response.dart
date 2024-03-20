import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'fortune_error_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class FortuneErrorResponse {
  @JsonKey(name: 'error_code')
  int? errorCode;
  @JsonKey(name: 'error_message')
  String? errorMessage;

  FortuneErrorResponse({
    @required this.errorCode,
    @required this.errorMessage,
  });

  factory FortuneErrorResponse.fromJson(Map<String, dynamic> json) => _$FortuneErrorResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FortuneErrorResponseToJson(this);
}
