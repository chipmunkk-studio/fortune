import 'package:dartz/dartz.dart';
import 'package:fortune/core/util/logger.dart';

import 'fortune_app_failures.dart';

class FortuneErrorMapper {
  FortuneFailure map(FortuneException exception) {
    final int errorCode = exception.code;
    final String errorMessage = exception.message;
    final String errorDescription = exception.description;

    FortuneLogger.error(
      code: errorCode.toString(),
      message: errorMessage,
      description: errorDescription,
    );

    // 계정 에러: 401/403 Unauthorized
    if (errorCode == 401 || errorCode == 403) {
      return AuthFailure(
        errorCode,
        errorMessage,
        errorDescription,
      );
    }
    // 클라이언트 에러: 400 이상 500 미만 (401/403은 이미 위에서 처리)
    else if (errorCode >= 400 && errorCode < 500) {
      return ClientFailure(
        errorCode,
        errorMessage,
        errorDescription,
      );
    }
    // 서버 에러: 500 이상
    else if (errorCode >= 500) {
      return ServerFailure(
        errorCode,
        errorMessage,
        errorDescription,
      );
    }
    // 알 수 없는 에러: 에러 코드 범위 외
    else {
      return UnKnownFailure(errorMessage);
    }
  }

  FortuneFailure mapAsFailure<T>(FortuneException error) => map(error);
}
