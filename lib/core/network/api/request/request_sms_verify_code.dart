import 'package:json_annotation/json_annotation.dart';

part 'request_sms_verify_code.g.dart';

@JsonSerializable(nullable: true, ignoreUnannotated: false)
class RequestSmsVerifyCode {
  @JsonKey(name: 'phoneNumber')
  String phoneNumber;

  RequestSmsVerifyCode({
    required this.phoneNumber,
  });

  factory RequestSmsVerifyCode.fromJson(Map<String, dynamic> json) => _$RequestSmsVerifyCodeFromJson(json);

  Map<String, dynamic> toJson() => _$RequestSmsVerifyCodeToJson(this);
}
