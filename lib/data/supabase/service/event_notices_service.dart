import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/data/supabase/ext.dart';
import 'package:foresh_flutter/data/supabase/request/request_event_notices.dart';
import 'package:foresh_flutter/data/supabase/response/eventnotice/event_notices_response.dart';
import 'package:foresh_flutter/data/supabase/service/service_ext.dart';
import 'package:foresh_flutter/domain/supabase/entity/eventnotice/event_notices_response.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EventNoticesService {
  static const fullSelectQuery = '*,'
      '${TableName.users}(*),'
      '${TableName.eventRewards}(*)';

  final _tableName = TableName.eventNotices;

  final SupabaseClient _client = Supabase.instance.client;

  EventNoticesService();

  // 모든 알림을 조회.
  Future<List<EventNoticesEntity>> findAllEventNotices() async {
    try {
      final response = await _client
          .from(_tableName)
          .select(
            fullSelectQuery,
          )
          .toSelect();
      if (response.isEmpty) {
        return List.empty();
      } else {
        final notices = response.map((e) => EventNoticesResponse.fromJson(e)).toList();
        return notices;
      }
    } on Exception catch (e) {
      throw (e.handleException()); // using extension method here
    }
  }

  // 아이디로 알림을 조회
  Future<EventNoticesEntity> findNoticeById(int noticeId) async {
    try {
      final response = await _client
          .from(_tableName)
          .select(
            fullSelectQuery,
          )
          .filter('id', 'eq', noticeId)
          .toSelect();
      if (response.isEmpty) {
        throw CommonFailure(errorMessage: '알림이 존재 하지 않습니다');
      } else {
        final missions = response.map((e) => EventNoticesResponse.fromJson(e)).toList();
        return missions.single;
      }
    } catch (e) {
      throw (e is Exception) ? e.handleException() : e;
    }
  }

  // 알림 업데이트.
  Future<void> update(
    int noticeId, {
    required RequestEventNotices request,
  }) async {
    EventNoticesEntity eventNotice = await findNoticeById(noticeId);

    final requestToUpdate = RequestEventNotices(
      users: request.users ?? eventNotice.user.id,
      searchText: request.searchText ?? eventNotice.searchText,
      eventRewards: request.eventRewards ?? eventNotice.eventReward.id,
      type: request.type ?? eventNotice.type.name,
      landingRoute: request.landingRoute ?? eventNotice.landingRoute,
      isRead: request.isRead ?? eventNotice.isRead,
      isReceived: request.isReceived ?? eventNotice.isReceive,
      headings: '',
      content: '',
    );

    try {
      final updateResponse = await _client
          .from(_tableName)
          .update(
            requestToUpdate.toJson(),
          )
          .eq('id', noticeId)
          .select(fullSelectQuery);
      return updateResponse.map((e) => EventNoticesResponse.fromJson(e)).toList().single;
    } catch (e) {
      throw (e is Exception) ? e.handleException() : e;
    }
  }

  // 알림 추가.
  Future<EventNoticesEntity> insert(RequestEventNotices request) async {
    try {
      final insertUser = await _client
          .from(_tableName)
          .insert(
            request.toJson(),
          )
          .select(fullSelectQuery);
      return insertUser.map((e) => EventNoticesResponse.fromJson(e)).toList().single;
    } catch (e) {
      throw (e is Exception) ? e.handleException() : e;
    }
  }
}
