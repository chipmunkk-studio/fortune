import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/core/util/mixpanel.dart';
import 'package:fortune/data/supabase/service/auth_service.dart';
import 'package:fortune/data/supabase/service/user_service.dart';
import 'package:fortune/domain/supabase/entity/agree_terms_entity.dart';
import 'package:fortune/domain/supabase/repository/auth_repository.dart';
import 'package:fortune/domain/supabase/request/request_verify_phone_number_param.dart';
import 'package:supabase/supabase.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthService _authService;
  final UserService _userService;
  final MixpanelTracker _mixpanelTracker;

  AuthRepositoryImpl(
    this._authService,
    this._userService,
    this._mixpanelTracker,
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
        description: e.message,
      );
    }
  }

  // 회원가입.
  @override
  Future<AuthResponse> signUp({
    required String phoneNumber,
    required int countryInfoId,
  }) async {
    try {
      await _userService.insert(
        phone: phoneNumber,
        countryInfoId: countryInfoId,
      );
      final response = await _authService.signUp(
        phoneNumber: phoneNumber,
      );
      _mixpanelTracker.trackEvent('회원 가입', properties: {'phone': phoneNumber});
      return response;
    } on FortuneFailure catch (e) {
      throw e.handleFortuneFailure(
        description: '${e.message}',
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
        description: FortuneTr.msgVerifyCode,
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
        description: e.message,
      );
    }
  }

  @override
  Future<AgreeTermsEntity> getTermsByIndex(int index) async {
    try {
      final AgreeTermsEntity terms = await _authService.getTermsByIndex(index);
      return terms;
    } on FortuneFailure catch (e) {
      throw e.handleFortuneFailure(
        description: e.message,
      );
    }
  }

  @override
  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _authService.signInWithEmail(
        email: email,
        password: password,
      );
      await _authService.persistSession(response.session!);
      return response;
    } on FortuneFailure catch (e) {
      throw e.handleFortuneFailure(
        description: '테스트 계정 로그인 실패',
      );
    }
  }

  @override
  Future<AuthResponse> signUpWithEmail({
    required String phoneNumber,
    required String email,
    required String password,
  }) async {
    try {
      // 회원이 없을 경우 추가.
      await _userService.insert(
        phone: phoneNumber,
        countryInfoId: 2,
      );
      final response = await _authService.signUpWithEmail(
        email: email,
        password: password,
      );
      await _authService.persistSession(response.session!);
      return response;
    } on FortuneFailure catch (e) {
      throw e.handleFortuneFailure(
        description: FortuneTr.msgUseNextTime,
      );
    }
  }
}
