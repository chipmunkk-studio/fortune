import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/core/util/logger.dart';
import 'package:foresh_flutter/data/supabase/request/request_user_notices_update.dart';
import 'package:foresh_flutter/data/supabase/service/user_notices_service.dart';
import 'package:foresh_flutter/domain/supabase/entity/user_notices_entity.dart';
import 'package:foresh_flutter/domain/supabase/repository/user_notices_repository.dart';

class UserNoticesRepositoryImpl extends UserNoticesRepository {
  final UserNoticesService userNoticesService;

  UserNoticesRepositoryImpl({
    required this.userNoticesService,
  });

  @override
  Future<void> deleteNoticeById(int noticeId) async {
    try {
      final result = await userNoticesService.delete(noticeId);
      return result;
    } on FortuneFailure catch (e) {
      FortuneLogger.error('errorCode: ${e.code}, errorMessage: ${e.message}');
      rethrow;
    }
  }

  @override
  Future<List<UserNoticesEntity>> findAllNoticesByUserId(int userId) async {
    try {
      final result = await userNoticesService.findAllNoticesByUserId(userId);
      return result;
    } on FortuneFailure catch (e) {
      FortuneLogger.error('errorCode: ${e.code}, errorMessage: ${e.message}');
      rethrow;
    }
  }

  @override
  Future<void> insertNotice(RequestUserNoticesUpdate content) async {
    try {
      final result = await userNoticesService.insert(content);
      return result;
    } on FortuneFailure catch (e) {
      FortuneLogger.error('errorCode: ${e.code}, errorMessage: ${e.message}');
      rethrow;
    }
  }
}
