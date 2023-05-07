
import 'package:dartz/dartz.dart';
import 'package:foresh_flutter/core/util/logger.dart';

import 'fortune_app_failures.dart';

abstract class FortuneErrorDataReference {
  static const common = 'common';

  static const errorClientInternal = 'errorClientInternal';
  static const errorClientUnknown = 'errorClientUnknown';
  static const errorClientAuth = 'errorClientAuth';
}

abstract class FortuneErrorStatus {
  static const int unknown = 998;
  static const int custom = 997;

  // 클라이언트 에러.
  static const int clientInternal = 996;

  // 인증되지 않은 사용자 요청일 경우 발생하는 에러.
  static const int unauthorized = 401;

  // 잘못된 요청.
  static const int badRequest = 10000;

  // 이미 획득한 마커
  static const int markerAlreadyAcquired = 10016;

  // 마커가 없을 경우.
  static const int hasNoTicket = 10017;

  // 서버에서 발생하는 에러.
  static const int internalServerError = 20000;

  // 서버에서 발생하는 스프링관련한 에러.
  static const int internalServerSpringError = 20001;
}

class FortuneErrorMapper {
  FortuneFailure map(FortuneException error) {
    try {
      final int? errorCode = error.errorCode;
      final String? errorType = error.errorType;
      final String? errorMessage = error.errorMessage;

      FortuneLogger.error("$errorCode: $errorMessage");
      switch (errorCode) {
        // 인증에러.
        case FortuneErrorStatus.unauthorized:
          return AuthFailure(errorCode, errorType, errorMessage);
        // 서버 에러.
        case FortuneErrorStatus.internalServerSpringError:
        case FortuneErrorStatus.internalServerError:
          return InternalServerFailure(errorCode, errorType, errorMessage);
        // 클라이언트 에러.
        case FortuneErrorStatus.clientInternal:
          return InternalClientFailure(errorMessage);
        // 그 외.
        default:
          return BadRequestFailure(errorCode, errorType, errorMessage);
      }
    } catch (e) {
      return UnKnownFailure(e.toString());
    }
  }

  Either<FortuneFailure, T> mapAsLeft<T>(FortuneException error) => left(map(error));
}
