import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';

import 'fortune_error_mapper.dart';

class FortuneException {
  final int? errorCode;
  final String? errorType;
  final String? errorMessage;

  FortuneException({
    required this.errorCode,
    required this.errorType,
    required this.errorMessage,
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

/// 인증에러.
class AuthFailure extends FortuneFailure {
  final int? errorCode;
  final String? errorType;
  final String? errorMessage;

  const AuthFailure(
    this.errorCode,
    this.errorType,
    this.errorMessage,
  ) : super(
          code: errorCode ?? FortuneErrorStatus.unauthorized,
          message: errorMessage,
        );

  factory AuthFailure.internal({
    int? errorCode,
    String? errorType,
    required String? errorMessage,
  }) =>
      AuthFailure(
        errorCode ?? HttpStatus.unauthorized,
        errorType ?? FortuneErrorDataReference.errorClientAuth,
        errorMessage,
      );

  @override
  List<Object?> get props => [message];
}

/// Bad Request.
class BadRequestFailure extends FortuneFailure {
  final int? errorCode;
  final String? errorType;
  final String? errorMessage;

  const BadRequestFailure(
    this.errorCode,
    this.errorType,
    this.errorMessage,
  ) : super(
          code: errorCode ?? FortuneErrorStatus.badRequest,
          message: errorMessage,
        );

  @override
  List<Object?> get props => [message];
}

/// 서버 에러.
class InternalServerFailure extends FortuneFailure {
  final String? errorType;
  final int? errorCode;
  final String? errorMessage;

  const InternalServerFailure(
    this.errorCode,
    this.errorType,
    this.errorMessage,
  ) : super(
          code: errorCode ?? FortuneErrorStatus.internalServerError,
          message: errorMessage,
        );

  @override
  List<Object?> get props => [message];
}

/// 클라이언트 에러.
class InternalClientFailure extends FortuneFailure {
  final String? errorMessage;

  InternalClientFailure(
    this.errorMessage,
  ) : super(
          code: FortuneErrorStatus.clientInternal,
          message: errorMessage ?? FortuneErrorDataReference.errorClientInternal.tr(),
        );

  @override
  List<Object?> get props => [message];
}

/// 알수 없는 에러.
class UnKnownFailure extends FortuneFailure {
  final String? errorMessage;

  UnKnownFailure(
    this.errorMessage,
  ) : super(
          code: FortuneErrorStatus.unknown,
          message: errorMessage ?? FortuneErrorDataReference.errorClientUnknown.tr(),
        );

  @override
  List<Object?> get props => [errorMessage];
}
