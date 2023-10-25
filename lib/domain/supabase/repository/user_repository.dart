import 'package:fortune/data/supabase/response/fortune_user_response.dart';
import 'package:fortune/domain/supabase/entity/fortune_user_entity.dart';
import 'package:fortune/domain/supabase/request/request_get_all_users_param.dart';

abstract class UserRepository {
  // 사용자 찾기.(null을 허용하지 않음) > 사용자가 없을 경우 무조건 에러가 필요한 경우
  Future<FortuneUserEntity> findUserByEmailNonNull({
    String? emailParam,
    required List<UserColumn> columnsToSelect,
  });

  // 사용자 찾기 (회원가입 시 사용자가 없다면 null 임)
  Future<FortuneUserEntity?> findUserByEmail(email);

  // 사용자 티켓 업데이트.
  Future<FortuneUserEntity> updateUserTicket(
    String email, {
    required int ticket,
    required int markerObtainCount,
  });

  // 사용자 닉네임 업데이트.
  Future<FortuneUserEntity> updateUserNickName(
    String email, {
    required String nickname,
  });

  // 사용자 프로필 업데이트.
  Future<FortuneUserEntity> updateUserProfile(
    String email, {
    required String filePath,
  });

  // 회원 탈퇴.
  Future<void> withdrawal(String email);

  // 회원 탈퇴 철회.
  Future<void> cancelWithdrawal(String email);

  Future<List<FortuneUserEntity>> getAllUsers(RequestRankingParam param);

  Future<String> getUserRanking(
    String paramEmail, {
    required int paramMarkerObtainCount,
    required int paramTicket,
    required String paramCreatedAt,
  });
}
