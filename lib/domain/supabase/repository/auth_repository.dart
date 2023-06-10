import 'package:foresh_flutter/core/util/usecase.dart';
import 'package:foresh_flutter/domain/supabase/entity/agree_terms_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRepository {
  // 로그인 > OTP 전송.
  Future<FortuneResult<void>> signInWithOtp({required String phoneNumber});

  // 회원가입.
  Future<FortuneResult<AuthResponse>> signUp({required String phoneNumber});

  // 휴대폰 번호 인증.
  Future<FortuneResult<AuthResponse>> verifyPhoneNumber({
    required String otpCode,
    required String phoneNumber,
  });

  // 약관 받아오기.
  Future<FortuneResult<List<AgreeTermsEntity>>> getTerms();
}
