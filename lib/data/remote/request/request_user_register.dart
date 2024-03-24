import 'package:json_annotation/json_annotation.dart';

part 'request_user_register.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class RequestUserRegister {
  @JsonKey(name: 'sign_up_token')
  final String signUpToken;

  @JsonKey(name: 'invite_token')
  final String? inviteToken;

  RequestUserRegister({
    required this.signUpToken,
    required this.inviteToken,
  });

  factory RequestUserRegister.fromJson(Map<String, dynamic> json) => _$RequestUserRegisterFromJson(json);

  Map<String, dynamic> toJson() => _$RequestUserRegisterToJson(this);
}
