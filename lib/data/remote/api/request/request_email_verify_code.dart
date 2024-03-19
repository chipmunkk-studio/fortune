import 'package:json_annotation/json_annotation.dart';

part 'request_email_verify_code.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class RequestEmailVerifyCode {
  @JsonKey(name: 'email')
  String email;

  @JsonKey(name: 'code')
  String code;

  RequestEmailVerifyCode({
    required this.email,
    required this.code,
  });

  factory RequestEmailVerifyCode.fromJson(Map<String, dynamic> json) => _$RequestEmailVerifyCodeFromJson(json);

  Map<String, dynamic> toJson() => _$RequestEmailVerifyCodeToJson(this);
}
