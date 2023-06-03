import 'dart:io';

import 'package:firebase_messaging_platform_interface/src/remote_message.dart';
import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/core/util/logger.dart';
import 'package:foresh_flutter/core/util/permission.dart';
import 'package:foresh_flutter/data/supabase/response/agree_terms_response.dart';
import 'package:foresh_flutter/data/supabase/service_ext.dart';
import 'package:foresh_flutter/domain/supabase/entity/agree_terms_entity.dart';
import 'package:foresh_flutter/domain/supabase/entity/notification_entity.dart';
import 'package:foresh_flutter/presentation/fortune_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  static const _termsTableName = "terms";
  static const supabaseSessionKey = 'supabase_session';
  static const _tag = '[AuthService] ';

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
    } on AuthException catch (e) {
      throw AuthFailure(
        errorCode: e.statusCode,
        errorMessage: e.message,
        exposureMessage: () {
          if (e.message.contains('Invalid login')) {
            return "인증번호 전송에 실패 했습니다.";
          } else {
            return "로그인 실패";
          }
        }(),
      );
    } catch (e) {
      throw UnknownFailure(
        errorCode: null,
        errorMessage: e.toString(),
      );
    }
  }

  // 회원가입.
  Future<AuthResponse> signUp({
    required String phoneNumber,
    required String password,
  }) async {
    try {
      final response = await authClient.signUp(
        phone: phoneNumber,
        password: password,
      );
      return response;
    } on AuthException catch (e) {
      throw AuthFailure(
        errorCode: e.statusCode,
        errorMessage: e.message,
        exposureMessage: () {
          if (e.message.contains('already registered')) {
            return "이미 가입된 사용자 입니다.";
          } else {
            return "회원가입 실패";
          }
        }(),
      );
    } catch (e) {
      throw UnknownFailure(
        errorCode: null,
        errorMessage: e.toString(),
      );
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
    } on AuthException catch (e) {
      throw AuthFailure(
        errorCode: e.statusCode,
        errorMessage: e.message,
        exposureMessage: "휴대폰번호 인증 실패",
      );
    } catch (e) {
      throw UnknownFailure(
        errorCode: null,
        errorMessage: e.toString(),
      );
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
        exposureMessage: "로그아웃 실패",
      );
    } catch (e) {
      throw UnknownFailure(
        errorCode: null,
        errorMessage: e.toString(),
      );
    }
  }

  // 필수/선택 약관 목록 받아오기.
  Future<List<AgreeTermsEntity>> getTerms() async {
    try {
      final List<dynamic> response = await client.from(_termsTableName).select("*").toSelect();
      final terms = response.map((e) => AgreeTermsResponse.fromJson(e)).toList();
      return terms;
    } on PostgrestException catch (e) {
      throw CommonFailure(
        errorCode: e.code,
        errorMessage: e.message,
        exposureMessage: "사용자를 찾을 수 없습니다.",
      );
    } catch (e) {
      throw UnknownFailure(
        errorCode: null,
        errorMessage: e.toString(),
      );
    }
  }

  // 세션 유지.
  Future<void> persistSession(Session session) async {
    FortuneLogger.info('PersistSession:: ${session.persistSessionString}');
    await preferences.setString(supabaseSessionKey, session.persistSessionString);
  }

  // 세션 복구
  Future<String> recoverSession(Map<String, dynamic>? data) async {
    final isAnyPermissionDenied = await FortunePermissionUtil.checkPermissionsStatus(
      Platform.isAndroid ? FortunePermissionUtil.androidPermissions : FortunePermissionUtil.iosPermissions,
    );
    final isJoinMember = preferences.containsKey(supabaseSessionKey);
    if (isAnyPermissionDenied && isJoinMember) {
      return handlePermissionDeniedState();
    } else if (isJoinMember) {
      return handleJoinMemberState(data);
    } else {
      return handleNoLoginState();
    }
  }

  Future<String> handlePermissionDeniedState() {
    FortuneLogger.info('RecoverSession:: 로그인 한 계정이 있음 (권한이 없음)');
    return Future.value(Routes.requestPermissionRoute);
  }

  Future<String> handleJoinMemberState(Map<String, dynamic>? data) async {
    FortuneLogger.info('RecoverSession:: 로그인 한 계정이 있음.');
    final jsonStr = preferences.getString(supabaseSessionKey)!;
    final response = await authClient.recoverSession(jsonStr);
    FortuneLogger.info('RecoverSession:: 계정 복구 성공. ${response.user!.email}');
    persistSession(response.session!);
    if (data != null) {
      FortuneLogger.info('RecoverSession:: 푸시 알림으로 진입');
      final entity = NotificationEntity.fromJson(data);
      return "${Routes.homeRoute}/${entity.landingRoute}";
    } else {
      return Routes.homeRoute;
    }
  }

  Future<String> handleNoLoginState() {
    FortuneLogger.info('RecoverSession:: 로그인 한 계정이 없음.');
    return Future.value(Routes.onBoardingRoute);
  }
}
