import 'dart:math';

import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/core/util/logger.dart';
import 'package:foresh_flutter/data/supabase/service/auth_service.dart';
import 'package:foresh_flutter/data/supabase/service/user_service.dart';
import 'package:foresh_flutter/domain/supabase/entity/agree_terms_entity.dart';
import 'package:foresh_flutter/domain/supabase/repository/auth_repository.dart';
import 'package:foresh_flutter/domain/supabase/request/request_verify_phone_number_param.dart';
import 'package:supabase/supabase.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthService _authService;
  final UserService _userService;

  AuthRepositoryImpl(
    this._authService,
    this._userService,
  );

  // 휴대폰 번호로 로그인 요청.
  @override
  Future<void> signInWithOtp({
    required String phoneNumber,
  }) async {
    try {
      final response = await _authService.signInWithOtp(phoneNumber: phoneNumber);
      return response;
    } on FortuneFailure catch (e) {
      FortuneLogger.error('errorCode: ${e.code}, errorMessage: ${e.message}');
      rethrow;
    }
  }

  // 회원가입.
  @override
  Future<AuthResponse> signUp({
    required String phoneNumber,
  }) async {
    try {
      await _userService.insert(phone: phoneNumber);
      final response = await _authService.signUp(
        phoneNumber: phoneNumber,
        password: _generatePassword(),
      );
      return response;
    } on FortuneFailure catch (e) {
      FortuneLogger.error('errorCode: ${e.code}, errorMessage: ${e.message}');
      rethrow;
    }
  }

  // 휴대폰 번호 인증.
  @override
  Future<AuthResponse> verifyPhoneNumber(RequestVerifyPhoneNumberParam param) async {
    try {
      // #1 휴대폰 번호 인증.
      final response = await _authService.verifyPhoneNumber(
        otpCode: param.verifyCode,
        phoneNumber: param.phoneNumber,
      );
      // #2 세션 저장.
      await _authService.persistSession(response.session!);
      return response;
    } on FortuneFailure catch (e) {
      FortuneLogger.error('errorCode: ${e.code}, errorMessage: ${e.message}');
      if (e is AuthFailure) {
        throw e.copyWith(
          errorMessage: '인증번호를 확인해주세요',
        );
      }
      rethrow;
    }
  }

  // 약관 받아 오기.
  @override
  Future<List<AgreeTermsEntity>> getTerms() async {
    try {
      final List<AgreeTermsEntity> terms = await _authService.getTerms();
      return terms;
    } on FortuneFailure catch (e) {
      FortuneLogger.error('errorCode: ${e.code}, errorMessage: ${e.message},');
      rethrow;
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
