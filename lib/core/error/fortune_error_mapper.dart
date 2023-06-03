import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:foresh_flutter/core/util/logger.dart';

import 'fortune_app_failures.dart';

class FortuneErrorMapper {
  FortuneFailure map(FortuneException error) {
    try {
      final int errorCode = int.parse(error.errorCode ?? "");
      final String? errorMessage = error.errorMessage;

      FortuneLogger.error("$errorCode: $errorMessage");
      switch (errorCode) {
        // 인증에러.
        case HttpStatus.forbidden:
        case HttpStatus.unauthorized:
          return AuthFailure(
            errorCode: errorCode.toString(),
            errorMessage: errorMessage,
          );
        // 공통에러
        default:
          return CommonFailure(
            errorCode: errorCode.toString(),
            errorMessage: errorMessage,
          );
      }
    } catch (e) {
      return UnknownFailure(
        errorMessage: e.toString(),
      );
    }
  }

  Either<FortuneFailure, T> mapAsLeft<T>(FortuneException error) => left(map(error));
}
