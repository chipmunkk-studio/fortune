import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/core/util/logger.dart';
import 'package:foresh_flutter/core/util/usecase.dart';
import 'package:foresh_flutter/data/supabase/service/auth_service.dart';
import 'package:foresh_flutter/data/supabase/service/user_service.dart';
import 'package:foresh_flutter/domain/supabase/entity/agree_terms_entity.dart';
import 'package:foresh_flutter/domain/supabase/entity/fortune_user_entity.dart';
import 'package:foresh_flutter/domain/supabase/repository/auth_repository.dart';
import 'package:supabase/supabase.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthService _authService;
  final UserService _userService;

  AuthRepositoryImpl(
    this._authService,
    this._userService,
  );

  // 휴대폰 번호로 로그인 요청.
  // - OTP 전송.
  @override
  Future<FortuneResult<void>> signInWithOtp({
    required String phoneNumber,
  }) async {
    try {
      final response = await _authService.signInWithOtp(phoneNumber: phoneNumber);
      return Right(response);
    } on FortuneFailure catch (e) {
      FortuneLogger.error('errorCode: ${e.code}, errorMessage: ${e.message}');
      return Left(e);
    }
  }

  // 회원가입.
  @override
  Future<FortuneResult<AuthResponse>> signUp({
    required String phoneNumber,
  }) async {
    try {
      // 회원가입.
      final response = await _authService.signUp(
        phoneNumber: phoneNumber,
        password: _generatePassword(),
      );
      return Right(response);
    } on FortuneFailure catch (e) {
      FortuneLogger.error('errorCode: ${e.code}, errorMessage: ${e.message}');
      return Left(e);
    }
  }

  // 휴대폰 번호 인증.
  @override
  Future<FortuneResult<AuthResponse>> verifyPhoneNumber({
    required String otpCode,
    required String phoneNumber,
  }) async {
    try {
      // #1 휴대폰 번호 인증.
      final response = await _authService.verifyPhoneNumber(
        otpCode: otpCode,
        phoneNumber: phoneNumber,
      );
      // #2 회원이 있는지 확인.
      final FortuneUserEntity? user = await _userService.findUserByPhone(phoneNumber);
      // #3 회원이 없다면 회원테이블에 등록.
      user ?? await _userService.insert(phone: phoneNumber);
      // #4 세션 저장.
      await _authService.persistSession(response.session!);
      return Right(response);
    } on FortuneFailure catch (e) {
      FortuneLogger.error('errorCode: ${e.code}, errorMessage: ${e.message}');
      return Left(e);
    }
  }

  // 약관 받아 오기.
  @override
  Future<FortuneResult<List<AgreeTermsEntity>>> getTerms() async {
    try {
      final List<AgreeTermsEntity> terms = await _authService.getTerms();
      return Right(terms);
    } on FortuneFailure catch (e) {
      FortuneLogger.error('errorCode: ${e.code}, errorMessage: ${e.message},');
      return Left(e);
    }
  }

  static _generatePassword() {
    // 비밀번호의 길이
    const length = 12;
    // 비밀번호에 사용할 문자
    const String allowedCharacters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#\$&*~';
    // 보안이 강화된 랜덤 숫자 생성기 생성
    final random = Random.secure();
    // allowedCharacters 문자열에서 랜덤한 문자를 선택하여 비밀번호를 생성
    final charCodes =
        List<int>.generate(length, (i) => allowedCharacters.codeUnits[random.nextInt(allowedCharacters.length)]);
    // 랜덤으로 생성된 문자 코드들을 문자열로 변환하여 비밀번호를 생성
    final password = String.fromCharCodes(charCodes);
    // 생성된 비밀번호 반환
    return password;
  }
}
