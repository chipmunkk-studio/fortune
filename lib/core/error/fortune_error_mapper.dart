import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:foresh_flutter/core/util/logger.dart';

import 'fortune_app_failures.dart';

abstract class FortuneErrorStatus {
  static const int unknown = 998;
  static const int custom = 997;

  // 클라이언트 에러.
  static const int clientInternal = 996;

  // 잘못된 요청.
  static const int badRequest = 10000;

  // 잘못된 요청에 대해 스프링에서 던지는 에러.
  static const int springBadRequest = 10001;

  // 유효성 검증 실패 에러.
  static const int validationError = 10002;

  // 인증되지 않은 사용자 요청일 경우 발생하는 에러.
  static const int unauthorized = 10003;

  // 이미 가입된 회원의 회원 요청일 경우 발생하는 에러.
  static const int duplicatedUser = 10004;

  // 존재하지 않는 유저 정보로 조회 요청인 경우.
  static const int notFoundUser = 10005;

  // 인증 번호 검증 전 요청 부터 진행하지 않은 경우.
  static const int preAuthenticationRequest = 10006;

  // 잘못된 인증번호로 검증 요청시 발생하는 에러.
  static const int invalidAuthenticationNumber = 10007;

  // 유효하지 않은 닉네임으로 회원가입 요청시 발생하는 에러.
  static const int validationNicknameError = 10008;

  // 유효하지 않은 핸드폰 번호로 회원 가입 요청시 발생하는 에러
  static const int validationPhoneNumberError = 10009;

  // 유효하지 않은 파일 사이즈로 회원 가입 요청 시 발생하는 에러
  static const int validationFileSizeError = 10010;

  // 제한된 인증번호 요청(1분간 1회) 시 발생하는 에러
  static const int restrictedAuthNumberError = 10011;

  // 이미 획득한 마커
  static const int markerAlreadyAcquired = 10012;

  // 라운드가 존재하지 않을 경우
  static const int roundNotExist = 10013;

  // 사용가능한 티켓이 없을 경우
  static const int hasNoTicket = 10014;

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
        // 잘못된 리퀘스트.
        case FortuneErrorStatus.validationError:
        case FortuneErrorStatus.springBadRequest:
        case FortuneErrorStatus.preAuthenticationRequest:
        case FortuneErrorStatus.invalidAuthenticationNumber:
        case FortuneErrorStatus.validationNicknameError:
        case FortuneErrorStatus.duplicatedUser:
        case FortuneErrorStatus.notFoundUser:
        case FortuneErrorStatus.badRequest:
        case FortuneErrorStatus.restrictedAuthNumberError:
        case FortuneErrorStatus.markerAlreadyAcquired:
        case FortuneErrorStatus.roundNotExist:
        case FortuneErrorStatus.hasNoTicket:
          return BadRequestFailure(errorCode, errorType, errorMessage?.tr());
        // 인증에러.
        case FortuneErrorStatus.unauthorized:
          return AuthFailure(errorCode, errorType, errorMessage?.tr());
        // 서버 에러.
        case FortuneErrorStatus.internalServerSpringError:
        case FortuneErrorStatus.internalServerError:
          return InternalServerFailure(errorCode, errorType, errorMessage);
        // 클라이언트 에러.
        case FortuneErrorStatus.clientInternal:
          return InternalClientFailure(errorMessage);
        // 그 외.
        default:
          return UnKnownFailure(errorMessage);
      }
    } catch (e) {
      return UnKnownFailure(e.toString());
    }
  }

  Either<FortuneFailure, T> mapAsLeft<T>(FortuneException error) => left(map(error));
}
