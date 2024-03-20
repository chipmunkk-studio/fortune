import 'package:fortune/domain/entity/verify_email_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'verify_email_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class VerifyEmailResponse extends VerifyEmailEntity {
  @JsonKey(name: 'accessToken')
  final String? accessToken_;
  @JsonKey(name: 'refreshToken')
  final String? refreshToken_;
  @JsonKey(name: 'signUpToken')
  final String? signUpToken_;

  VerifyEmailResponse({
    required this.accessToken_,
    required this.refreshToken_,
    required this.signUpToken_,
  }) : super(
          accessToken: accessToken_ ?? '',
          refreshToken: refreshToken_ ?? '',
          signUpToken: signUpToken_ ?? '',
        );

  factory VerifyEmailResponse.fromJson(Map<String, dynamic> json) => _$VerifyEmailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyEmailResponseToJson(this);
}
