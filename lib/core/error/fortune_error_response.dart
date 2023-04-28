import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'fortune_error_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class FortuneErrorResponse {
  @JsonKey(name: 'errorCode')
  int? code; // 10007
  @JsonKey(name: 'type')
  String? type; // preAuthenticationRequest
  @JsonKey(name: 'message')
  String? message; // 서버에서 주는 에러메세지.

  FortuneErrorResponse({@required this.code, @required this.message, @required this.type});

  factory FortuneErrorResponse.fromJson(Map<String, dynamic> json) => _$FortuneErrorResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FortuneErrorResponseToJson(this);
}
