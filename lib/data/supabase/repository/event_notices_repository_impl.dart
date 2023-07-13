import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/core/util/logger.dart';
import 'package:foresh_flutter/data/supabase/request/request_event_notices.dart';
import 'package:foresh_flutter/data/supabase/service/event_notices_service.dart';
import 'package:foresh_flutter/domain/supabase/entity/eventnotice/event_notices_response.dart';
import 'package:foresh_flutter/domain/supabase/repository/event_notices_repository.dart';

class EventNoticesRepositoryImpl extends EventNoticesRepository {
  final EventNoticesService eventNoticesService;

  EventNoticesRepositoryImpl({
    required this.eventNoticesService,
  });

  @override
  Future<List<EventNoticesEntity>> findAllNotices() async {
    try {
      final result = await eventNoticesService.findAllEventNotices();
      return result;
    } on FortuneFailure catch (e) {
      FortuneLogger.error('errorCode: ${e.code}, errorMessage: ${e.message}');
      rethrow;
    }
  }

  @override
  Future<EventNoticesEntity> insertNotice(RequestEventNotices content) async {
    try {
      final result = await eventNoticesService.insert(content);
      return result;
    } on FortuneFailure catch (e) {
      FortuneLogger.error('errorCode: ${e.code}, errorMessage: ${e.message}');
      rethrow;
    }
  }
}
