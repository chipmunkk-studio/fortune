import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/core/util/logger.dart';
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
  Future<List<AlarmFeedsEntity>> findAllNotices() async {
    try {
      final result = await alarmFeedsService.findAllEventNotices();
      return result;
    } on FortuneFailure catch (e) {
      throw e.handleFortuneFailure(
        description: '이벤트 알림 불러오기 실패',
      );
    }
  }

  @override
  Future<AlarmFeedsEntity> insertNotice(RequestEventNotices content) async {
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
