import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:foresh_flutter/core/message_ext.dart';
import 'package:foresh_flutter/core/util/logger.dart';
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
  final String? description;

  const FortuneFailure({
    this.code,
    this.message,
    this.description,
  }) : super();

  FortuneFailure copyWith({
    String? code,
    String? message,
    String? description,
  });
}

/// 인증 에러.
class AuthFailure extends FortuneFailure {
  final String? errorCode;
  final String? errorMessage;
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
}

/// 공통 에러.
class CommonFailure extends FortuneFailure {
  final String? errorMessage;
  final String? errorDescription;

  CommonFailure({
    this.errorMessage,
    this.errorDescription,
  }) : super(
          code: HttpStatus.badRequest.toString(),
          message: errorMessage,
          description: errorDescription,
        );

  @override
  List<Object?> get props => [code, message, description];

  @override
  CommonFailure copyWith({
    String? code,
    String? message,
    String? description,
  }) {
    return CommonFailure(
      errorMessage: message ?? errorMessage,
      errorDescription: description ?? errorDescription,
    );
  }
}

/// 알 수 없는 에러.
class NetworkFailure extends FortuneFailure {
  final String? errorCode;
  final String? errorMessage;
  final String? errorDescription;

  const NetworkFailure({
    this.errorCode = '400',
    this.errorMessage,
    this.errorDescription,
  }) : super(
          code: errorCode,
          message: errorMessage,
          description: errorDescription,
        );

  @override
  List<Object?> get props => [code, message, description];

  @override
  NetworkFailure copyWith({
    String? code,
    String? message,
    String? description,
  }) {
    return NetworkFailure(
      errorCode: code ?? errorCode,
      errorMessage: message ?? errorMessage,
      errorDescription: description ?? errorDescription,
    );
  }
}

/// 알 수 없는 에러.
class UnknownFailure extends FortuneFailure {
  final String? errorCode;
  final String? errorMessage;
  final String? errorDescription;

  const UnknownFailure({
    this.errorCode = '999',
    this.errorMessage,
    this.errorDescription,
  }) : super(
          code: errorCode,
          message: errorMessage,
          description: errorDescription,
        );

  @override
  List<Object?> get props => [code, message, description];

  @override
  UnknownFailure copyWith({
    String? code,
    String? message,
    String? description,
  }) {
    return UnknownFailure(
      errorCode: code ?? errorCode,
      errorMessage: message ?? errorMessage,
      errorDescription: description ?? errorDescription,
    );
  }
}

/// 비즈니스 에러
class CustomFailure extends FortuneFailure {
  final String? errorDescription;

  const CustomFailure({
    this.errorDescription,
  }) : super(
          message: errorDescription,
        );

  @override
  List<Object?> get props => [code, message, description];

  @override
  CustomFailure copyWith({
    String? code,
    String? message,
    String? description,
  }) {
    return CustomFailure(
      errorDescription: description ?? errorDescription,
    );
  }
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
        errorMessage: authException.message,
      );
    } else if (this is HttpException || this is SocketException || this is TimeoutException) {
      return NetworkFailure(
        errorMessage: FortuneCommonMessage.confirmNetworkConnection,
      ); // your own exception for handling network errors
    } else {
      return UnknownFailure(errorMessage: toString());
    }
  }
}

extension FortuneFailureX on FortuneFailure {
  FortuneFailure handleFortuneFailure({
    String? description,
  }) {
    if (this is CustomFailure) {
      return this;
    }
    FortuneLogger.error(
      code: code,
      message: message,
      description: description,
    );
    return copyWith(description: description);
  }
}
