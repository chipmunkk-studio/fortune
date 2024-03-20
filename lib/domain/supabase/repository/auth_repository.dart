import 'package:fortune/domain/supabase/entity/agree_terms_entity.dart';
import 'package:fortune/domain/supabase/request/request_verify_phone_number_param.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRepository {
  // 휴대폰 번호 인증.
  Future<AuthResponse> verifyOTP(RequestVerifyEmailParam param);

  // 약관 받아오기.
  Future<List<AgreeTermsEntity>> getTerms();

  // 약관 받아오기.
  Future<AgreeTermsEntity> getTermsByIndex(int index);

  Future<AuthResponse> signUpWithEmail({
    required String email,
  });

  Future<void> signInWithEmail({
    required String email,
  });

  Future<AuthResponse> signInWithEmailWithTest({
    required String email,
    required String password,
    required bool isRegistered,
  });
}
