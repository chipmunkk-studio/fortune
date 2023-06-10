
import 'package:foresh_flutter/core/util/usecase.dart';
import 'package:foresh_flutter/domain/supabase/entity/fortune_user_entity.dart';

abstract class UserRepository {

  // 사용자 찾기.
  Future<FortuneResult<FortuneUserEntity?>> findUserByPhone(phoneNumber);
}
