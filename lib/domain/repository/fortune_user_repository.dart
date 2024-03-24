import 'package:fortune/domain/entity/email_verify_code_entity.dart';
import 'package:fortune/domain/entity/fortune_user_entity.dart';
import 'package:fortune/domain/entity/user_token_entity.dart';
import 'package:fortune/domain/entity/verify_email_entity.dart';

abstract class FortuneUserRepository {
  /// 회원가입/로그인.
  Future<FortuneUserEntity> me();
}
