import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/data/supabase/request/request_alarm_feeds.dart';
import 'package:fortune/data/supabase/response/alarmfeed/alarm_feeds_response.dart';
import 'package:fortune/data/supabase/service/alarm_feeds_service.dart';
import 'package:fortune/domain/supabase/entity/eventnotice/alarm_feeds_entity.dart';
import 'package:fortune/domain/supabase/repository/alarm_feeds_repository.dart';

class AlarmFeedsRepositoryImpl extends AlarmFeedsRepository {
  final AlarmFeedsService alarmFeedsService;

  AlarmFeedsRepositoryImpl({
    required this.alarmFeedsService,
  });

  @override
  Future<List<AlarmFeedsEntity>> findAllAlarmsByUserId(
    int userId, {
    required List<AlarmFeedColumn> columnsToSelect,
  }) async {
    try {
      final alarms = await alarmFeedsService.findAllAlarmFeeds(
        userId,
        columnsToSelect: columnsToSelect,
      );
      return alarms;
    } on FortuneFailureDeprecated catch (e) {
      throw e.handleFortuneFailure();
    }
  }

  @override
  Future<AlarmFeedsEntity> insertAlarm(RequestAlarmFeeds content) async {
    try {
      final result = await alarmFeedsService.insert(content);
      return result;
    } on FortuneFailureDeprecated catch (e) {
      throw e.handleFortuneFailure();
    }
  }

  @override
  Future<void> readAllAlarm(int userId) async {
    try {
      final allAlarms = await findAllAlarmsByUserId(
        userId,
        columnsToSelect: [
          AlarmFeedColumn.id,
          AlarmFeedColumn.isRead,
        ],
      );
      await Future.wait(
        allAlarms.map((element) async {
          if (!element.isRead) {
            await alarmFeedsService.update(
              element.id,
              request: RequestAlarmFeeds(
                isRead: true,
              ),
            );
          }
        }),
      );
    } on FortuneFailureDeprecated catch (e) {
      throw e.handleFortuneFailure();
    }
  }
}
