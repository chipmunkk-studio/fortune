import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/data/supabase/request/request_event_notice_read_update.dart';
import 'package:foresh_flutter/data/supabase/request/request_user_notices_update.dart';
import 'package:foresh_flutter/data/supabase/response/event_notice_read_response.dart';
import 'package:foresh_flutter/data/supabase/response/event_notice_response.dart';
import 'package:foresh_flutter/data/supabase/response/user_notices_response.dart';
import 'package:foresh_flutter/data/supabase/service_ext.dart';
import 'package:foresh_flutter/domain/supabase/entity/event_notice_entity.dart';
import 'package:foresh_flutter/domain/supabase/entity/event_notice_read_entity.dart';
import 'package:foresh_flutter/domain/supabase/entity/user_notices_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EventNoticesService {
  static const _eventNoticesTableName = "event_notices";
  static const _eventNoticesTableReadName = "event_notices_read";
  static const _fullSelectQuery = '*';

  final SupabaseClient _client;

  EventNoticesService(this._client);

  // 내가 읽지 않은 모든 알림을 조회.
  Future<List<EventNoticeEntity>> findAllNoticesByUserId(int userId) async {
    try {
      // 모든 알림을 조회.
      final List<dynamic> allNotificationsResponse =
          await _client.from(_eventNoticesTableName).select(_fullSelectQuery).toSelect();
      final List<EventNoticeEntity> allNotificationsEntity =
          allNotificationsResponse.map((e) => EventNoticeResponse.fromJson(e)).toList();

      // 알림 리드 테이블 조회.
      final List<dynamic> readNotificationResponse =
          await _client.from(_eventNoticesTableReadName).select(_fullSelectQuery).eq('user', userId).toSelect();
      final List<EventNoticeReadEntity> readNotificationEntity =
          readNotificationResponse.map((e) => EventNoticeReadResponse.fromJson(e)).toList();
      final List<int> readNotificationIds = readNotificationEntity.map((e) => e.notice).toList();

      // 읽지 않은 알람 필터.
      final unreadNotifications = allNotificationsEntity
          .where(
            (notification) => !readNotificationIds.contains(
              notification.id,
            ),
          )
          .toList();

      if (unreadNotifications.isEmpty) {
        return List.empty();
      } else {
        return unreadNotifications;
      }
    } on Exception catch (e) {
      throw (e.handleException()); // using extension method here
    }
  }

  // 알림 읽기 처리.
  Future<void> insertRead(RequestEventNoticeReadUpdate content) async {
    try {
      final insertUser = await _client
          .from(_eventNoticesTableReadName)
          .insert(
            content.toJson(),
          )
          .select(_fullSelectQuery);
      return insertUser.map((e) => EventNoticeReadResponse.fromJson(e)).toList().single;
    } on Exception catch (e) {
      throw (e.handleException()); // using extension method here
    }
  }
}
