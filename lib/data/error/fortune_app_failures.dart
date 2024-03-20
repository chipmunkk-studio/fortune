import 'dart:io';

import 'package:equatable/equatable.dart';

class FortuneException {
  final int code;
  final String message;

  final String description;

  FortuneException({
    required this.code,
    required this.message,
    this.description = '',
  });
}

abstract class FortuneFailure extends Equatable {
  final int code;
  final String message;
  final String description;

  const FortuneFailure({
    required this.message,
    required this.code,
    this.description = '',
  }) : super();
}

/// 인증 에러.
class AuthFailure extends FortuneFailure {
  final int errorCode;
  final String errorMessage;
  final String errorDescription;

  const AuthFailure(
    this.errorCode,
    this.errorMessage,
    this.errorDescription,
  ) : super(
          code: errorCode,
          message: errorMessage,
          description: errorDescription,
        );

  factory AuthFailure.internal({
    int? errorCode,
    required String? errorMessage,
    required String? errorDescription,
  }) =>
      AuthFailure(
        errorCode ?? HttpStatus.unauthorized,
        errorMessage = 'Internal Client AuthFailure',
        errorDescription ?? '',
      );

  @override
  List<Object?> get props => [
        errorCode,
        errorMessage,
      ];
}

/// 클라이언트 에러.
class ClientFailure extends FortuneFailure {
  final int errorCode;
  final String errorMessage;
  final String errorDescription;

  const ClientFailure(
    this.errorCode,
    this.errorMessage,
    this.errorDescription,
  ) : super(
          code: errorCode,
          message: errorMessage,
          description: errorDescription,
        );

  @override
  List<Object?> get props => [
        errorCode,
        errorMessage,
        errorDescription,
      ];
}

/// 서버 에러.
class ServerFailure extends FortuneFailure {
  final int errorCode;
  final String errorMessage;
  final String errorDescription;

  const ServerFailure(
    this.errorCode,
    this.errorMessage,
    this.errorDescription,
  ) : super(
          code: errorCode,
          message: errorMessage,
          description: errorDescription,
        );

  @override
  List<Object?> get props => [
        errorCode,
        errorMessage,
        errorDescription,
      ];
}

/// 알수 없는 에러.
class UnKnownFailure extends FortuneFailure {
  final String errorMessage;

  const UnKnownFailure(
    this.errorMessage,
  ) : super(
          code: 999,
          message: errorMessage,
        );

  @override
  List<Object?> get props => [errorMessage];
}
