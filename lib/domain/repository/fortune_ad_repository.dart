import 'package:fortune/domain/entity/fortune_user_entity.dart';

abstract class FortuneAdRepository {
  /// 회원가입/로그인.
  Future<FortuneUserEntity> onShowAdComplete(int ts);
}
