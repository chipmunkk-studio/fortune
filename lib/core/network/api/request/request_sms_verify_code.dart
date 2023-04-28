import 'package:json_annotation/json_annotation.dart';

part 'request_sms_verify_code.g.dart';

@JsonSerializable(nullable: true, ignoreUnannotated: false)
class RequestSmsVerifyCode {
  @JsonKey(name: 'phoneNumber')
  String phoneNumber;
  @JsonKey(name: 'countryCode')
  String countryCode;

  RequestSmsVerifyCode({
    required this.phoneNumber,
    required this.countryCode,
  });

  factory RequestSmsVerifyCode.fromJson(Map<String, dynamic> json) => _$RequestSmsVerifyCodeFromJson(json);

  Map<String, dynamic> toJson() => _$RequestSmsVerifyCodeToJson(this);
}