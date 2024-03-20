import 'package:fortune/domain/entity/email_verify_code_entity.dart';
import 'package:fortune/domain/entity/verify_email_entity.dart';

abstract class AuthNormalRepository {
  /// 회원가입/로그인.
  Future<EmailVerifyCodeEntity> requestEmailVerifyCode({
    required String email,
  });

  /// 이메일 인증
  Future<VerifyEmailEntity> verifyEmail({
    required String email,
    required String code,
  });
}
