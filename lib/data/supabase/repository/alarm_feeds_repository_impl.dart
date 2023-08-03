import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/data/supabase/request/request_event_notices.dart';
import 'package:foresh_flutter/data/supabase/service/alarm_feeds_service.dart';
import 'package:foresh_flutter/domain/supabase/entity/eventnotice/alarm_feeds_entity.dart';
import 'package:foresh_flutter/domain/supabase/repository/alarm_feeds_repository.dart';

class AlarmFeedsRepositoryImpl extends AlarmFeedsRepository {
  final AlarmFeedsService alarmFeedsService;

  AlarmFeedsRepositoryImpl({
    required this.alarmFeedsService,
  });

  @override
  Future<List<AlarmFeedsEntity>> findAllAlarmsByUserId(int userId) async {
    try {
      final alarms = await alarmFeedsService.findAllAlarmFeeds(userId);
      alarms.sort((a, b) {
        if (a.isReceive != b.isReceive) {
          // isReceive가 true인 알람이 앞쪽에 오도록 정렬
          return a.isReceive ? 1 : -1;
        }
        // isReceive 값이 같은 경우, 생성 시간이 빠른 순으로 정렬
        return b.createdAt.compareTo(a.createdAt);
      });
      return alarms;
    } on FortuneFailure catch (e) {
      throw e.handleFortuneFailure(
        description: '이벤트 알림 불러오기 실패',
      );
    }
  }

  @override
  Future<AlarmFeedsEntity> insertAlarm(RequestEventNotices content) async {
    try {
      final result = await alarmFeedsService.insert(content);
      return result;
    } on FortuneFailure catch (e) {
      throw e.handleFortuneFailure(
        description: '이벤트 알림 추가 실패',
      );
    }
  }
}
