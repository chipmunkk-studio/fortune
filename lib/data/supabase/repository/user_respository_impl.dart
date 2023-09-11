import 'package:foresh_flutter/core/error/failure/common_failure.dart';
import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/core/message_ext.dart';
import 'package:foresh_flutter/data/local/datasource/local_datasource.dart';
import 'package:foresh_flutter/data/supabase/request/request_fortune_user.dart';
import 'package:foresh_flutter/data/supabase/service/user_service.dart';
import 'package:foresh_flutter/domain/supabase/entity/fortune_user_entity.dart';
import 'package:foresh_flutter/domain/supabase/repository/user_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserRepositoryImpl extends UserRepository {
  final UserService _userService;
  final LocalDataSource _localDataSource;

  UserRepositoryImpl(
    this._userService,
    this._localDataSource,
  );

  // 휴대폰 번호로 현재 사용자 찾기.
  @override
  Future<FortuneUserEntity> findUserByPhoneNonNull() async {
    try {
      final String currentPhoneNumber = Supabase.instance.client.auth.currentUser?.phone ?? '';
      final String testAccount = await _localDataSource.getTestAccount();
      final String phoneNumber = currentPhoneNumber.isNotEmpty ? currentPhoneNumber : testAccount;
      final FortuneUserEntity? user = await _userService.findUserByPhone(phoneNumber);
      if (user == null) {
        throw CommonFailure(errorMessage: FortuneTr.notExistUser);
      }
      return user;
    } on FortuneFailure catch (e) {
      throw e.handleFortuneFailure(
        description: FortuneTr.notFoundUser,
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
        description: FortuneTr.notFoundUser,
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
        description: FortuneTr.notUpdateUser,
      );
    }
  }

  @override
  Future<FortuneUserEntity> updateUserProfile(String filePath) async {
    try {
      // 테스트 계정 때문에 아이디 찾아야됨.
      final user = await findUserByPhoneNonNull();
      return await _userService.updateProfile(
        user,
        filePath: filePath,
      );
    } on FortuneFailure catch (e) {
      throw e.handleFortuneFailure(
        description: FortuneTr.notUpdateUser,
      );
    }
  }
}
