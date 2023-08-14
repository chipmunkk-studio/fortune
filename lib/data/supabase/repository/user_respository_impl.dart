import 'package:foresh_flutter/core/error/failure/common_failure.dart';
import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/core/message_ext.dart';
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
      final String? phoneNumber = Supabase.instance.client.auth.currentUser?.phone;
      final FortuneUserEntity? user = await _userService.findUserByPhone(phoneNumber);
      if (user == null) {
        throw CommonFailure(errorMessage: FortuneCommonMessage.notExistUser);
      }
      return user;
    } on FortuneFailure catch (e) {
      throw e.handleFortuneFailure(
        description: FortuneCommonMessage.notFoundUser,
      );
    }
  }

  // 사용자 찾기.
  @override
  Future<FortuneUserEntity?> findUserByPhone(phoneNumber) async {
    try {
      final FortuneUserEntity? user = await _userService.findUserByPhone(phoneNumber);
      return user;
    } on FortuneFailure catch (e) {
      throw e.handleFortuneFailure(
        description: FortuneCommonMessage.notFoundUser,
      );
    }
  }

  // 사용자 업데이트.
  @override
  Future<FortuneUserEntity> updateUser(FortuneUserEntity user) async {
    try {
      return await _userService.update(
        user.phone,
        request: RequestFortuneUser(
          nickname: user.nickname,
          ticket: user.ticket,
          markerObtainCount: user.markerObtainCount,
        ),
      );
    } on FortuneFailure catch (e) {
      throw e.handleFortuneFailure(
        description: FortuneCommonMessage.notUpdateUser,
      );
    }
  }
}
