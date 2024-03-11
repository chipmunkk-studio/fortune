import 'dart:io';

import 'package:equatable/equatable.dart';

class FortuneException {
  final int code;
  final String message;

  FortuneException({
    required this.code,
    required this.message,
  });
}

abstract class FortuneFailure extends Equatable {
  final int code;
  final String? message;

  const FortuneFailure({
    required this.message,
    required this.code,
  }) : super();
}

/// 인증 에러.
class AuthFailure extends FortuneFailure {
  final int errorCode;
  final String errorMessage;

  const AuthFailure(
    this.errorCode,
    this.errorMessage,
  ) : super(
          code: errorCode,
          message: errorMessage,
        );

  factory AuthFailure.internal({
    int? errorCode,
    required String? errorMessage,
  }) =>
      AuthFailure(
        errorCode ?? HttpStatus.unauthorized,
        errorMessage = 'Internal Client AuthFailure',
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

  const ClientFailure(
    this.errorCode,
    this.errorMessage,
  ) : super(
          code: errorCode,
          message: errorMessage,
        );

  @override
  List<Object?> get props => [
        errorCode,
        errorMessage,
      ];
}

/// 서버 에러.
class ServerFailure extends FortuneFailure {
  final int errorCode;
  final String errorMessage;

  const ServerFailure(
    this.errorCode,
    this.errorMessage,
  ) : super(
          code: errorCode,
          message: errorMessage,
        );

  @override
  List<Object?> get props => [
        errorCode,
        errorMessage,
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
