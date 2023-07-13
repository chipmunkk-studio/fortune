import 'package:foresh_flutter/data/supabase/request/request_event_notices.dart';
import 'package:foresh_flutter/domain/supabase/entity/eventnotice/event_notices_response.dart';

abstract class EventNoticesRepository {
  // 사용자 알림 모두 조회.
  Future<List<EventNoticesEntity>> findAllNotices();

  // 사용자 알림 추가
  Future<EventNoticesEntity> insertNotice(RequestEventNotices content);
}
