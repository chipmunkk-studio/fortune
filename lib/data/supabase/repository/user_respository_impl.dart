import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/core/util/logger.dart';
import 'package:foresh_flutter/data/supabase/request/request_fortune_user.dart';
import 'package:foresh_flutter/data/supabase/service/user_service.dart';
import 'package:foresh_flutter/domain/supabase/entity/fortune_user_entity.dart';
import 'package:foresh_flutter/domain/supabase/repository/user_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserRepositoryImpl extends UserRepository {
  final UserService _userService;

  UserRepositoryImpl(
    this._userService,
  );

  // 휴대폰 번호로 현재 사용자 찾기.
  @override
  Future<FortuneUserEntity> findUserByPhoneNonNull() async {
    try {
      final FortuneUserEntity? user = await _userService.findUserByPhone(
        Supabase.instance.client.auth.currentUser?.phone,
      );
      if (user == null) {
        throw CommonFailure(errorMessage: '사용자가 존재하지 않습니다');
      }
      return user;
    } on FortuneFailure catch (e) {
      FortuneLogger.error('errorCode: ${e.code}, errorMessage: ${e.message}');
      rethrow;
    }
  }

  // 사용자를 찾음.
  @override
  Future<FortuneUserEntity?> findUserByPhone(phoneNumber) async {
    try {
      final FortuneUserEntity? user = await _userService.findUserByPhone(phoneNumber);
      return user;
    } on FortuneFailure catch (e) {
      FortuneLogger.error('errorCode: ${e.code}, errorMessage: ${e.message}');
      rethrow;
    }
  }

  @override
  Future<FortuneUserEntity> updateUser(FortuneUserEntity user) async {
    return await _userService.update(
      user.phone,
      request: RequestFortuneUser(
        nickname: user.nickname,
        ticket: user.ticket,
        markerObtainCount: user.markerObtainCount,
      ),
    );
  }
}
