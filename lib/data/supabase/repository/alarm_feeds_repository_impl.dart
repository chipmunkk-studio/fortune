import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/data/supabase/request/request_alarm_feeds.dart';
import 'package:fortune/data/supabase/service/alarm_feeds_service.dart';
import 'package:fortune/domain/supabase/entity/eventnotice/alarm_feeds_entity.dart';
import 'package:fortune/domain/supabase/repository/alarm_feeds_repository.dart';

class AlarmFeedsRepositoryImpl extends AlarmFeedsRepository {
  final AlarmFeedsService alarmFeedsService;

  AlarmFeedsRepositoryImpl({
    required this.alarmFeedsService,
  });

  @override
  Future<List<AlarmFeedsEntity>> findAllAlarmsByUserId(int userId) async {
    try {
      final alarms = await alarmFeedsService.findAllAlarmFeeds(userId);
      return alarms;
    } on FortuneFailure catch (e) {
      throw e.handleFortuneFailure(
        description: '이벤트 알림 불러오기 실패',
      );
    }
  }

  @override
  Future<AlarmFeedsEntity> insertAlarm(RequestAlarmFeeds content) async {
    try {
      final result = await alarmFeedsService.insert(content);
      return result;
    } on FortuneFailure catch (e) {
      throw e.handleFortuneFailure(
        description: '이벤트 알림 추가 실패',
      );
    }
  }

  @override
  Future<void> readAllAlarm(int userId) async {
    try {
      final allAlarms = await findAllAlarmsByUserId(userId);
      await Future.wait(allAlarms.map((element) async {
        await alarmFeedsService.update(
          element.id,
          request: RequestAlarmFeeds(
            isRead: true,
          ),
        );
      }));
    } on FortuneFailure catch (e) {
      throw e.handleFortuneFailure(
        description: '이벤트 알림 추가 실패',
      );
    }
  }
}
