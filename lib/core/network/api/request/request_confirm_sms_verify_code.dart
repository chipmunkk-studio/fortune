import 'package:json_annotation/json_annotation.dart';

part 'request_confirm_sms_verify_code.g.dart';

@JsonSerializable(nullable: true, ignoreUnannotated: false)
class RequestConfirmSmsVerifyCode {
  @JsonKey(name: 'phoneNumber')
  String phoneNumber;
  @JsonKey(name: 'authenticationNumber')
  int authenticationNumber;
  @JsonKey(name: 'pushToken')
  String? pushToken;

  RequestConfirmSmsVerifyCode({
    required this.phoneNumber,
    required this.authenticationNumber,
    required this.pushToken,
  });

  factory RequestConfirmSmsVerifyCode.fromJson(Map<String, dynamic> json) =>
      _$RequestConfirmSmsVerifyCodeFromJson(json);

  Map<String, dynamic> toJson() => _$RequestConfirmSmsVerifyCodeToJson(this);
}
