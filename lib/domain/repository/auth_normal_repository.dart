import 'package:fortune/domain/entity/request_email_verify_code_entity.dart';

abstract class AuthNormalRepository {
  /// 회원가입/로그인.
  Future<RequestEmailVerifyCodeEntity> requestEmailVerifyCode({
    required String email,
  });

}