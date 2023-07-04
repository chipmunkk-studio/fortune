import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/data/supabase/request/request_user_notices_update.dart';
import 'package:foresh_flutter/data/supabase/response/user_notices_response.dart';
import 'package:foresh_flutter/data/supabase/service_ext.dart';
import 'package:foresh_flutter/domain/supabase/entity/user_notices_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserNoticesService {
  static const _userNoticesTableName = "user_notices";
  static const _fullSelectQuery = '*, user(*)';

  final SupabaseClient _client;

  UserNoticesService(this._client);

  // 모든 알림을 조회.
  Future<List<UserNoticesEntity>> findAllNoticesByUserId(int userId) async {
    try {
      final response = await _client
          .from(_userNoticesTableName)
          .select(
            _fullSelectQuery,
          )
          .filter('user', 'eq', userId)
          .toSelect();
      if (response.isEmpty) {
        return List.empty();
      } else {
        final notices = response.map((e) => UserNoticesResponse.fromJson(e)).toList();
        return notices;
      }
    } on Exception catch (e) {
      throw (e.handleException()); // using extension method here
    }
  }

  // 아이디로 알림을 조회
  Future<UserNoticesEntity> findNoticeById(int noticeId) async {
    try {
      final response = await _client
          .from(_userNoticesTableName)
          .select(
            _fullSelectQuery,
          )
          .filter('id', 'eq', noticeId)
          .toSelect();
      if (response.isEmpty) {
        throw CommonFailure(errorMessage: '알림이 존재 하지 않습니다');
      } else {
        final missions = response.map((e) => UserNoticesResponse.fromJson(e)).toList();
        return missions.single;
      }
    } on Exception catch (e) {
      throw (e.handleException()); // using extension method here
    }
  }

  // 알림 삭제.
  Future<void> delete(int noticeId) async {
    DateTime oneMinuteAgo = DateTime.now().subtract(const Duration(minutes: 1));
    try {
      await _client
          .from(
            _userNoticesTableName,
          )
          .delete()
          .eq('id', noticeId);
    } on Exception catch (e) {
      throw (e.handleException()); // using extension method here
    }
  }

  // 30일 전 알림 삭제.
  Future<void> deleteMonthAgo() async {
    DateTime oneMonthAgo = DateTime.now().subtract(const Duration(days: 30));
    try {
      await _client
          .from(
            _userNoticesTableName,
          )
          .delete()
          .lte('created_at', oneMonthAgo.toIso8601String());
    } on Exception catch (e) {
      throw (e.handleException()); // using extension method here
    }
  }

  // 알림 추가.
  Future<void> insert(RequestUserNoticesUpdate content) async {
    try {
      final insertUser = await _client
          .from(_userNoticesTableName)
          .insert(
            content.toJson(),
          )
          .select(_fullSelectQuery);
      return insertUser.map((e) => UserNoticesResponse.fromJson(e)).toList().single;
    } on Exception catch (e) {
      throw (e.handleException()); // using extension method here
    }
  }
}
