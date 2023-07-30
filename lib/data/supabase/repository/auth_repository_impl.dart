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
      throw e.handleFortuneFailure(
        description: '로그인 요청 실패',
      );
    }
  }

  // 회원가입.
  @override
  Future<AuthResponse> signUp({
    required String phoneNumber,
  }) async {
    try {
      // 회원이 없을 경우 추가.
      await _userService.insert(phone: phoneNumber);
      final response = await _authService.signUp(
        phoneNumber: phoneNumber,
      );
      return response;
    } on FortuneFailure catch (e) {
      throw e.handleFortuneFailure(
        description: '회원가입 실패',
      );
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
      throw e.handleFortuneFailure(
        description: '인증 번호를 확인해주세요',
      );
    }
  }

  // 약관 받아 오기.
  @override
  Future<List<AgreeTermsEntity>> getTerms() async {
    try {
      final List<AgreeTermsEntity> terms = await _authService.getTerms();
      return terms;
    } on FortuneFailure catch (e) {
      throw e.handleFortuneFailure(
        description: '약관을 받아 오지 못했습니다',
      );
    }
  }
}
