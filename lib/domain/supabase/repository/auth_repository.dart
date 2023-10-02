import 'package:fortune/domain/supabase/entity/agree_terms_entity.dart';
import 'package:fortune/domain/supabase/request/request_verify_phone_number_param.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRepository {
  // 로그인 > OTP 전송.
  Future<void> signInWithOtp({required String phoneNumber});

  // 회원가입. > OTP 전송.
  Future<AuthResponse> signUp({
    required String phoneNumber,
    required int countryInfoId,
  });

  // 회원가입(테스트 계정용)
  @override
  Future<AuthResponse> signUpWithEmail({
    required String phoneNumber,
    required String email,
    required String password,
  });

  // 로그인(테스트 계정용)
  @override
  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  });

  // 휴대폰 번호 인증.
  Future<AuthResponse> verifyPhoneNumber(RequestVerifyPhoneNumberParam param);

  // 약관 받아오기.
  Future<List<AgreeTermsEntity>> getTerms();

  // 약관 받아오기.
  Future<AgreeTermsEntity> getTermsByIndex(int index);
}
