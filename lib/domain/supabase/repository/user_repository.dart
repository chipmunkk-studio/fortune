import 'package:fortune/core/util/usecase.dart';
import 'package:fortune/domain/supabase/entity/fortune_user_entity.dart';

abstract class UserRepository {
  // 사용자 찾기.(null을 허용하지 않음) > 사용자가 없을 경우 무조건 에러가 필요한 경우
  Future<FortuneUserEntity> findUserByPhoneNonNull();

  // 사용자 찾기 (회원가입 시 사용자가 없다면 null 임)
  Future<FortuneUserEntity?> findUserByPhone(phoneNumber);

  // 사용자 업데이트.
  Future<FortuneUserEntity> updateUser(FortuneUserEntity user);

  // 사용자 프로필 업데이트.
  Future<FortuneUserEntity> updateUserProfile(String filePath);
}
