import 'package:json_annotation/json_annotation.dart';

part 'request_verify_email.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class RequestVerifyEmail {
  @JsonKey(name: 'email')
  final String email;

  @JsonKey(name: 'code')
  final String code;

  RequestVerifyEmail({
    required this.email,
    required this.code,
  });

  factory RequestVerifyEmail.fromJson(Map<String, dynamic> json) => _$RequestVerifyEmailFromJson(json);

  Map<String, dynamic> toJson() => _$RequestVerifyEmailToJson(this);
}
