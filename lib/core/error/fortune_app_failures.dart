import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:foresh_flutter/core/error/fortune_error_message.dart';

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

  AuthFailure(
    this.errorCode,
    this.errorType,
    this.errorMessage,
  ) : super(
          code: errorCode ?? FortuneErrorStatus.unauthorized,
          message: getErrorDataMessage(errorCode, errorType, errorMessage),
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

  BadRequestFailure(
    this.errorCode,
    this.errorType,
    this.errorMessage,
  ) : super(
          code: errorCode ?? FortuneErrorStatus.badRequest,
          message: getErrorDataMessage(errorCode, errorType, errorMessage),
        );

  @override
  List<Object?> get props => [message];
}

/// 스프링 bad request.(클라이언트)
class SpringBadRequestFailure extends FortuneFailure {
  final int? errorCode;
  final String? errorType;
  final String? errorMessage;

  SpringBadRequestFailure(
    this.errorCode,
    this.errorType,
    this.errorMessage,
  ) : super(
          code: errorCode ?? FortuneErrorStatus.springBadRequest,
          message: getErrorDataMessage(errorCode, errorType, errorMessage),
        );

  @override
  List<Object?> get props => [message];
}

/// 유효성 검사.
class ValidationFailure extends FortuneFailure {
  final String? errorType;
  final int? errorCode;
  final String? errorMessage;

  ValidationFailure(
    this.errorCode,
    this.errorType,
    this.errorMessage,
  ) : super(
          code: errorCode ?? FortuneErrorStatus.validationError,
          message: getErrorDataMessage(errorCode, errorType, errorMessage),
        );

  @override
  List<Object?> get props => [message];
}

/// Not Found.
class NotFoundFailure extends FortuneFailure {
  final String? errorType;
  final int? errorCode;
  final String? errorMessage;

  NotFoundFailure(
    this.errorCode,
    this.errorType,
    this.errorMessage,
  ) : super(
          code: errorCode ?? FortuneErrorStatus.duplicatedUser,
          message: getErrorDataMessage(errorCode, errorType, errorMessage),
        );

  @override
  List<Object?> get props => [message];
}

/// 서버 에러.
class InternalServerFailure extends FortuneFailure {
  final String? errorType;
  final int? errorCode;
  final String? errorMessage;

  InternalServerFailure(
    this.errorCode,
    this.errorType,
    this.errorMessage,
  ) : super(
          code: errorCode ?? FortuneErrorStatus.internalServerError,
          message: getErrorDataMessage(errorCode, errorType, errorMessage),
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
