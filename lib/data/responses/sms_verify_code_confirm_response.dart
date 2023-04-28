import 'package:foresh_flutter/domain/entities/sms_verify_result_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sms_verify_code_confirm_response.g.dart';

@JsonSerializable(nullable: true, ignoreUnannotated: false)
class SmsVerifyCodeConfirmResponse extends SmsVerifyCodeConfirmEntity {
  @JsonKey(name: 'registered')
  final bool? registered_;

  @JsonKey(name: 'accessToken')
  final String? accessToken_;

  @JsonKey(name: 'refreshToken')
  final String? refreshToken_;

  const SmsVerifyCodeConfirmResponse({
    required this.registered_,
    required this.accessToken_,
    required this.refreshToken_,
  }) : super(
          registered: registered_ ?? false,
          accessToken: accessToken_,
          refreshToken: refreshToken_,
        );

  factory SmsVerifyCodeConfirmResponse.fromJson(Map<String, dynamic> json) =>
      _$SmsVerifyCodeConfirmResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SmsVerifyCodeConfirmResponseToJson(this);
}
