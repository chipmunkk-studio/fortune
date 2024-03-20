import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/core/util/mixpanel.dart';
import 'package:fortune/data/supabase/response/fortune_user_response.dart';
import 'package:fortune/data/supabase/service/auth_service.dart';
import 'package:fortune/data/supabase/service/user_service.dart';
import 'package:fortune/domain/supabase/entity/agree_terms_entity.dart';
import 'package:fortune/domain/supabase/repository/auth_repository.dart';
import 'package:fortune/domain/supabase/request/request_verify_phone_number_param.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthService _authService;
  final FortuneUserService _userService;

  final MixpanelTracker _tracker;

  AuthRepositoryImpl(
    this._authService,
    this._userService,
    this._tracker,
  );

  // 약관 받아 오기.
  @override
  Future<List<AgreeTermsEntity>> getTerms() async {
    try {
      final List<AgreeTermsEntity> terms = await _authService.getTerms();
      return terms;
    } on FortuneFailureDeprecated catch (e) {
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
    } on FortuneFailureDeprecated catch (e) {
      throw e.handleFortuneFailure(
        description: e.message,
      );
    }
  }

  @override
  Future<AuthResponse> verifyOTP(RequestVerifyEmailParam param) async {
    try {
      final response = await _authService.verifyOTP(
        email: param.email,
        otpCode: param.verifyCode,
      );
      final user = await _userService.findUserByEmail(
        param.email,
        columnsToSelect: [
          UserColumn.id,
        ],
      );
      if (user == null) {
        // 회원이 없을 경우 추가.
        await _userService.insert(email: param.email);
        _tracker.trackEvent('회원가입');
      }
      await _authService.persistSession(response.session!);
      return response;
    } on FortuneFailureDeprecated catch (e) {
      throw e.handleFortuneFailure(
        description: e.message,
      );
    }
  }

  @override
  Future<AuthResponse> signUpWithEmail({
    required String email,
  }) async {
    try {
      final response = await _authService.signUpWithEmail(email: email);
      return response;
    } on FortuneFailureDeprecated catch (e) {
      throw e.handleFortuneFailure(
        description: e.message,
      );
    }
  }

  @override
  Future<void> signInWithEmail({
    required String email,
  }) async {
    try {
      await _authService.signInWithEmail(email: email);
    } on FortuneFailureDeprecated catch (e) {
      throw e.handleFortuneFailure(
        description: FortuneTr.msgUseNextTime,
      );
    }
  }

  @override
  Future<AuthResponse> signInWithEmailWithTest({
    required String email,
    required String password,
    required bool isRegistered,
  }) async {
    try {
      final response = await _authService.signInWithEmailWithTest(
        email: email,
        password: password,
        isRegistered: isRegistered,
      );
      if (!isRegistered) {
        await _userService.insert(email: email);
      }
      await _authService.persistSession(response.session!);
      return response;
    } on FortuneFailureDeprecated catch (e) {
      throw e.handleFortuneFailure(
        description: e.message,
      );
    }
  }
}
