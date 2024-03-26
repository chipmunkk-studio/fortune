import 'package:fortune/domain/entity/fortune_user_entity.dart';

abstract class FortuneUserRepository {
  /// 회원가입/로그인.
  Future<FortuneUserEntity> me();
}
