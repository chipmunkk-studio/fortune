import 'package:fortune/core/error/failure/common_failure.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/data/supabase/request/request_alarm_feeds.dart';
import 'package:fortune/data/supabase/response/alarmfeed/alarm_feeds_response.dart';
import 'package:fortune/data/supabase/service_ext.dart';
import 'package:fortune/data/supabase/supabase_ext.dart';
import 'package:fortune/domain/supabase/entity/eventnotice/alarm_feeds_entity.dart';
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
  Future<List<AlarmFeedsEntity>> findAllAlarmFeeds(
    int userId, {
    required List<AlarmFeedColumn> columnsToSelect,
  }) async {

    final selectColumns = columnsToSelect.map((column) {
      if (column == AlarmFeedColumn.alarmRewards) {
        return '${TableName.alarmRewardHistory}(${AlarmRewardHistoryService.fullSelectQuery})';
      } else if (column == AlarmFeedColumn.users) {
        return '${TableName.users}(*)';
      }
      return column.name;
    }).toList();

    try {
      final List<dynamic> response = await _client
          .from(_tableName)
          .select(selectColumns.isEmpty ? fullSelectQuery : selectColumns.join(","))
          .match({TableName.users: userId})
          .order(AlarmFeedColumn.createdAt.name, ascending: false)
          .toSelect();

      if (response.isEmpty) {
        return List.empty();
      }
      return response.map((e) => AlarmFeedsResponse.fromJson(e)).toList();
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
    int alarmId, {
    required RequestAlarmFeeds request,
  }) async {
    AlarmFeedsEntity eventNotice = await findNoticeById(alarmId);

    final requestToUpdate = RequestAlarmFeeds(
      users: request.users ?? eventNotice.user.id,
      alarmRewardHistory: request.alarmRewardHistory ?? eventNotice.reward.id,
      type: request.type ?? eventNotice.type.name,
      isRead: request.isRead ?? eventNotice.isRead,
      headings: request.headings ?? eventNotice.headings,
      content: request.content ?? eventNotice.content,
    );

    try {
      final updateResponse = await _client
          .from(_tableName)
          .update(
            requestToUpdate.toJson(),
          )
          .eq('id', alarmId)
          .select(fullSelectQuery);
      return updateResponse.map((e) => AlarmFeedsResponse.fromJson(e)).toList().single;
    } catch (e) {
      throw (e is Exception) ? e.handleException() : e;
    }
  }

  // 알림 추가.
  Future<AlarmFeedsEntity> insert(RequestAlarmFeeds request) async {
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
