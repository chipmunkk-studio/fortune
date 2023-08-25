import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:foresh_flutter/core/error/failure/auth_failure.dart';
import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/core/util/logger.dart';
import 'package:foresh_flutter/core/util/permission.dart';
import 'package:foresh_flutter/data/supabase/response/agree_terms_response.dart';
import 'package:foresh_flutter/data/supabase/service/service_ext.dart';
import 'package:foresh_flutter/domain/supabase/entity/agree_terms_entity.dart';
import 'package:foresh_flutter/presentation/fortune_router.dart';
import 'package:foresh_flutter/presentation/login/bloc/login.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  static const _termsTableName = "terms";
  static const supabaseSessionKey = 'supabase_session';

  final GoTrueClient authClient;
  final SharedPreferences preferences;
  final SupabaseClient client;

  AuthService({
    required this.client,
    required this.authClient,
    required this.preferences,
  });

  // 로그인.
  Future<void> signInWithOtp({
    required String phoneNumber,
  }) async {
    try {
      return await authClient.signInWithOtp(phone: phoneNumber);
    } catch (e) {
      throw (e is Exception) ? e.handleException() : e;
    }
  }

  // 회원가입.
  Future<AuthResponse> signUp({
    required String phoneNumber,
  }) async {
    final generatePassword = () {
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
    }();

    try {
      final response = await authClient.signUp(
        phone: phoneNumber,
        password: generatePassword,
      );
      return response;
    } catch (e) {
      throw (e is Exception) ? e.handleException() : e;
    }
  }

  // 휴대폰 번호 인증.
  Future<AuthResponse> verifyPhoneNumber({
    required String otpCode,
    required String phoneNumber,
  }) async {
    try {
      final response = await authClient.verifyOTP(
        token: otpCode,
        phone: phoneNumber,
        type: OtpType.sms,
      );
      return response;
    } catch (e) {
      throw (e is Exception) ? e.handleException() : e;
    }
  }

  // 로그아웃.
  Future<void> signOut() async {
    try {
      await authClient.signOut();
    } on AuthException catch (e) {
      throw AuthFailure(
        errorCode: e.statusCode,
        errorMessage: e.message,
      );
    } catch (e) {
      throw (e is Exception) ? e.handleException() : e;
    }
  }

  // 필수/선택 약관 목록 받아오기.
  Future<List<AgreeTermsEntity>> getTerms() async {
    try {
      final List<dynamic> response = await client.from(_termsTableName).select("*").toSelect();
      final terms = response.map((e) => AgreeTermsResponse.fromJson(e)).toList();
      return terms;
    } catch (e) {
      throw (e is Exception) ? e.handleException() : e;
    }
  }

  // 세션 복구
  Future<String> recoverSession(Map<String, dynamic> data) async {
    final isAnyPermissionDenied = await FortunePermissionUtil.checkPermissionsStatus(
      Platform.isAndroid ? FortunePermissionUtil.androidPermissions : FortunePermissionUtil.iosPermissions,
    );
    final isSignedMember = preferences.containsKey(supabaseSessionKey);
    // #1 권한이 없을 경우.
    if (isAnyPermissionDenied) {
      if (isSignedMember) {
        return handlePermissionDeniedState();
      } else {
        return handleNoLoginState();
      }
    }
    // #2 권한이 있을 경우.
    else {
      return handleJoinMemberState(data);
    }
  }

  Future<String> handlePermissionDeniedState() {
    FortuneLogger.info('RecoverSession:: 로그인 한 계정이 있음 (권한이 없음)');
    return Future.value(Routes.requestPermissionRoute);
  }

  Future<String> handleJoinMemberState(Map<String, dynamic> data) async {
    FortuneLogger.info('RecoverSession:: 로그인 한 계정이 있음. ');
    // 세션이 만료된 경우.
    final currentLoginUserState = await refreshSession();
    if (currentLoginUserState == LoginUserState.needToLogin) {
      return "${Routes.loginRoute}/${currentLoginUserState.name}";
    }
    return data.isNotEmpty ? "${Routes.mainRoute}/${jsonEncode(data)}" : Routes.mainRoute;
  }

  Future<String> handleNoLoginState() {
    FortuneLogger.info('RecoverSession:: 로그인 한 계정이 없음.');
    return Future.value(Routes.onBoardingRoute);
  }

  Future<LoginUserState> refreshSession() async {
    try {
      final authClient = Supabase.instance.client.auth;
      final session = authClient.currentSession;
      if (session == null || JwtDecoder.isExpired(session.accessToken)) {
        FortuneLogger.info('RecoverSession:: 세션 만료. ${session?.accessToken}');
        return LoginUserState.needToLogin;
      } else {
        final jsonStr = preferences.getString(supabaseSessionKey)!;
        final response = await authClient.recoverSession(jsonStr);
        FortuneLogger.info('RecoverSession:: 계정 복구 성공. ${response.user?.phone}');
        await persistSession(response.session!);
        return LoginUserState.none;
      }
    } catch (e) {
      FortuneLogger.info('refreshSession:: 계정 복구 실패. ${e.toString()}');
      return LoginUserState.needToLogin;
    }
  }

  Future<void> persistSession(Session session) async {
    FortuneLogger.info('PersistSession:: ${session.persistSessionString}');
    await preferences.setString(supabaseSessionKey, session.persistSessionString);
  }
}
