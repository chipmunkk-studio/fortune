import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/data/supabase/response/alarmfeed/alarm_feeds_response.dart';
import 'package:foresh_flutter/data/supabase/supabase_ext.dart';
import 'package:foresh_flutter/data/supabase/request/request_event_notices.dart';
import 'package:foresh_flutter/data/supabase/service/service_ext.dart';
import 'package:foresh_flutter/domain/supabase/entity/eventnotice/alarm_feeds_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'alarm_reward_history_service.dart';

class AlarmFeedsService {
  static const fullSelectQuery = '*,'
      '${TableName.users}(*),'
      '${TableName.alarmRewardHistory}(${AlarmRewardHistoryService.fullSelectQuery})';

  final _tableName = TableName.alarmFeeds;

  final SupabaseClient _client = Supabase.instance.client;

  AlarmFeedsService();

  // 모든 알림을 조회.
  Future<List<AlarmFeedsEntity>> findAllEventNotices() async {
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
        final notices = response.map((e) => AlarmFeedsResponse.fromJson(e)).toList();
        return notices;
      }
    } catch (e) {
      throw (e is Exception) ? e.handleException() : e;
    }
  }

  // 아이디로 알림을 조회
  Future<AlarmFeedsEntity> findNoticeById(int noticeId) async {
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
        final alarm = response.map((e) => AlarmFeedsResponse.fromJson(e)).toList();
        return alarm.single;
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
    AlarmFeedsEntity eventNotice = await findNoticeById(noticeId);

    final requestToUpdate = RequestEventNotices(
      users: request.users ?? eventNotice.user.id,
      eventRewardHistory: request.eventRewardHistory ?? eventNotice.eventRewardHistory.id,
      type: request.type ?? eventNotice.type.name,
      isRead: request.isRead ?? eventNotice.isRead,
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
      return updateResponse.map((e) => AlarmFeedsResponse.fromJson(e)).toList().single;
    } catch (e) {
      throw (e is Exception) ? e.handleException() : e;
    }
  }

  // 알림 추가.
  Future<AlarmFeedsEntity>  insert(RequestEventNotices request) async {
    try {
      final insertUser = await _client
          .from(_tableName)
          .insert(
            request.toJson(),
          )
          .select(fullSelectQuery);
      return insertUser.map((e) => AlarmFeedsResponse.fromJson(e)).toList().single;
    } catch (e) {
      throw (e is Exception) ? e.handleException() : e;
    }
  }
}
