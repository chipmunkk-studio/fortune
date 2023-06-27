import 'package:foresh_flutter/core/util/usecase.dart';
import 'package:foresh_flutter/domain/supabase/entity/fortune_user_entity.dart';

abstract class UserRepository {
  // 사용자 찾기.
  Future<FortuneUserEntity> findUserByPhone();

  // 사용자 찾기 (회원가입 시 사용자가 없다면 null 이 필요함.)
  Future<FortuneResult<FortuneUserEntity?>> findUserByPhoneEither(phoneNumber);

  // 사용자 업데이트.
  Future<FortuneUserEntity> updateUser(FortuneUserEntity user);
}
