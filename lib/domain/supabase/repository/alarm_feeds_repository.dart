import 'package:foresh_flutter/data/supabase/request/request_event_notices.dart';
import 'package:foresh_flutter/domain/supabase/entity/eventnotice/alarm_feeds_entity.dart';

abstract class AlarmFeedsRepository {
  // 사용자 알림 모두 조회.
  Future<List<AlarmFeedsEntity>> findAllAlarmsByUserId(int userId);

  // 사용자 알림 추가
  Future<AlarmFeedsEntity> insertAlarm(RequestEventNotices content);

}
