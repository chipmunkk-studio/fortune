import 'package:foresh_flutter/data/supabase/request/request_event_notice_read_update.dart';
import 'package:foresh_flutter/domain/supabase/entity/event_notice_entity.dart';
import 'package:foresh_flutter/domain/supabase/entity/event_notice_read_entity.dart';

abstract class EventNoticesRepository {
  // 사용자 알림 모두 조회.
  Future<List<EventNoticeEntity>> findAllNoticesByUserId(int userId);

  // 사용자 알림 추가
  Future<EventNoticeReadEntity> insertNotice(RequestEventNoticeReadUpdate content);
}
