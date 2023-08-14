import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth_failure.g.dart';

/// 인증 에러.
@JsonSerializable(ignoreUnannotated: false)
class AuthFailure extends FortuneFailure {
  @JsonKey(name: 'errorCode')
  final String? errorCode;
  @JsonKey(name: 'errorMessage')
  final String? errorMessage;
  @JsonKey(name: 'errorDescription')
  final String? errorDescription;

  const AuthFailure({
    this.errorCode,
    this.errorMessage,
    this.errorDescription,
  }) : super(
          code: errorCode,
          message: errorMessage,
          description: errorDescription,
        );

  @override
  AuthFailure copyWith({
    String? code,
    String? message,
    String? description,
  }) {
    return AuthFailure(
      errorCode: code ?? errorCode,
      errorMessage: message ?? errorMessage,
      errorDescription: description ?? errorDescription,
    );
  }

  @override
  List<Object?> get props => [code, message, description];

  factory AuthFailure.fromJson(Map<String, dynamic> json) => _$AuthFailureFromJson(json);

  Map<String, dynamic> toJson() => _$AuthFailureToJson(this);
}
