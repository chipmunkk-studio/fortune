import 'package:foresh_flutter/core/util/usecase.dart';
import 'package:foresh_flutter/domain/supabase/entity/agree_terms_entity.dart';
import 'package:foresh_flutter/domain/supabase/request/request_verify_phone_number_param.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRepository {
  // 로그인 > OTP 전송.
  Future<void> signInWithOtp({required String phoneNumber});

  // 회원가입. > OTP 전송.
  Future<AuthResponse> signUp({required String phoneNumber});

  // 휴대폰 번호 인증.
  Future<AuthResponse> verifyPhoneNumber(RequestVerifyPhoneNumberParam param);

  // 약관 받아오기.
  Future<List<AgreeTermsEntity>> getTerms();
}
