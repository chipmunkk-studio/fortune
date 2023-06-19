import 'package:foresh_flutter/core/util/usecase.dart';
import 'package:foresh_flutter/domain/supabase/entity/fortune_user_entity.dart';

abstract class UserRepository {
  // 사용자 찾기.
  Future<FortuneUserEntity> findUserByPhone(phoneNumber);

  // 사용자 찾기 (회원가입 시 사용자가 없다면 null 이 필요함.)
  Future<FortuneResult<FortuneUserEntity?>> findUserByPhoneEither(phoneNumber);

  // 쓰레기 제거.
  Future<FortuneUserEntity> reduceTrash({
    required String phoneNumber,
    required int trashCount,
  });
}
