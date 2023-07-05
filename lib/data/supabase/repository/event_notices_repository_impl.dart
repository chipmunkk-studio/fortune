import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/core/util/logger.dart';
import 'package:foresh_flutter/data/supabase/request/request_event_notice_read_update.dart';
import 'package:foresh_flutter/data/supabase/service/event_notices_service.dart';
import 'package:foresh_flutter/domain/supabase/entity/event_notice_entity.dart';
import 'package:foresh_flutter/domain/supabase/entity/event_notice_read_entity.dart';
import 'package:foresh_flutter/domain/supabase/repository/event_notices_repository.dart';

class EventNoticesRepositoryImpl extends EventNoticesRepository {
  final EventNoticesService eventNoticesService;

  EventNoticesRepositoryImpl({
    required this.eventNoticesService,
  });

  @override
  Future<List<EventNoticeEntity>> findAllNoticesByUserId(int userId) async {
    try {
      final result = await eventNoticesService.findAllNoticesByUserId(userId);
      return result;
    } on FortuneFailure catch (e) {
      FortuneLogger.error('errorCode: ${e.code}, errorMessage: ${e.message}');
      rethrow;
    }
  }

  @override
  Future<EventNoticeReadEntity> insertNotice(RequestEventNoticeReadUpdate content) async {
    try {
      final result = await eventNoticesService.insertRead(content);
      return result;
    } on FortuneFailure catch (e) {
      FortuneLogger.error('errorCode: ${e.code}, errorMessage: ${e.message}');
      rethrow;
    }
  }
}
