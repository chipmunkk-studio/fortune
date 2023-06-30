import 'package:foresh_flutter/data/supabase/request/request_user_notices_update.dart';
import 'package:foresh_flutter/domain/supabase/entity/user_notices_entity.dart';

abstract class UserNoticesRepository {
  // 사용자 알림 모두 조회.
  Future<List<UserNoticesEntity>> findAllNoticesByUserId(int userId);

  // 사용자 알림 삭제.
  Future<void> deleteNoticeById(int noticeId);

  // 사용자 알림 추가
  Future<void> insertNotice(RequestUserNoticesUpdate content);
}
