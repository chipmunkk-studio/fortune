import 'package:equatable/equatable.dart';

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
}

/// 인증 에러.
class AuthFailure extends FortuneFailure {
  final String? errorCode;
  final String? errorMessage;
  final String? exposureMessage;

  const AuthFailure({
    this.errorCode,
    this.errorMessage,
    this.exposureMessage,
  }) : super(
    code: errorCode,
    message: errorMessage,
    description: exposureMessage,
  );

  @override
  List<Object?> get props => [errorMessage, errorCode];
}

/// 공통 에러.
class CommonFailure extends FortuneFailure {
  final String? errorCode;
  final String? errorMessage;
  final String? exposureMessage;

  const CommonFailure({
    this.errorCode,
    this.errorMessage,
    this.exposureMessage,
  }) : super(
    code: errorCode,
    message: errorMessage,
    description: exposureMessage,
  );

  @override
  List<Object?> get props => [message, errorCode];
}

/// 알 수 없는 에러.
class UnknownFailure extends FortuneFailure {
  final String? errorCode;
  final String? errorMessage;
  final String? exposureMessage;

  const UnknownFailure({
    this.errorCode = '999',
    this.errorMessage,
    this.exposureMessage = "알 수 없는 에러",
  }) : super(
    code: errorCode,
    message: errorMessage,
    description: exposureMessage,
  );

  @override
  List<Object?> get props => [message, errorCode];
}

