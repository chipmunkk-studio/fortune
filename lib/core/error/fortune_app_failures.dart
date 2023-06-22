import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FortuneException {
  final String? errorCode;
  final String? errorMessage;

  FortuneException({
    required this.errorCode,
    required this.errorMessage,
  });
}

abstract class FortuneFailure extends Equatable {
  final String? code;
  final String? message;

  const FortuneFailure({
    this.code,
    this.message,
  }) : super();
}

/// 인증 에러.
class AuthFailure extends FortuneFailure {
  final String? errorCode;
  final String? errorMessage;

  const AuthFailure({
    this.errorCode,
    this.errorMessage,
  }) : super(
          code: errorCode,
          message: errorMessage,
        );

  @override
  List<Object?> get props => [errorMessage, errorCode];
}

/// 공통 에러.
class CommonFailure extends FortuneFailure {
  final String? errorMessage;

  CommonFailure({
    this.errorMessage,
  }) : super(
          code: HttpStatus.badRequest.toString(),
          message: errorMessage,
        );

  @override
  List<Object?> get props => [message];
}

/// 알 수 없는 에러.
class NetworkFailure extends FortuneFailure {
  final String? errorCode;
  final String? errorMessage;

  const NetworkFailure({
    this.errorCode = '400',
    this.errorMessage,
  }) : super(
          code: errorCode,
          message: errorMessage,
        );

  @override
  List<Object?> get props => [message, errorCode];
}

/// 알 수 없는 에러.
class UnknownFailure extends FortuneFailure {
  final String? errorCode;
  final String? errorMessage;

  const UnknownFailure({
    this.errorCode = '999',
    this.errorMessage,
  }) : super(
          code: errorCode,
          message: errorMessage,
        );

  @override
  List<Object?> get props => [message, errorCode];
}

extension FortuneExceptionX on Exception {
  FortuneFailure handleException() {
    if (this is PostgrestException) {
      final postgrestException = this as PostgrestException;
      if (postgrestException.message.contains("Token") || postgrestException.message.contains("JWT")) {
        return AuthFailure(
          errorCode: postgrestException.code,
          errorMessage: postgrestException.message,
        );
      } else {
        return CommonFailure(
          errorMessage: postgrestException.message,
        );
      }
    } else if (this is AuthException) {
      final authException = this as AuthException;
      return AuthFailure(
        errorCode: authException.statusCode,
        errorMessage: "인증 정보를 갱신합니다.",
      );
    } else if (this is HttpException || this is SocketException || this is TimeoutException) {
      return const NetworkFailure(errorMessage: '네트워크 연결 상태를 확인해주세요'); // your own exception for handling network errors
    } else {
      return UnknownFailure(errorMessage: toString());
    }
  }
}
