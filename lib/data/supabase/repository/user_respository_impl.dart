import 'package:fortune/core/error/failure/common_failure.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/data/local/datasource/local_datasource.dart';
import 'package:fortune/data/supabase/request/request_fortune_user.dart';
import 'package:fortune/data/supabase/service/user_service.dart';
import 'package:fortune/domain/supabase/entity/fortune_user_entity.dart';
import 'package:fortune/domain/supabase/repository/user_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserRepositoryImpl extends UserRepository {
  final UserService _userService;
  final LocalDataSource _localDataSource;
  final supabaseClient = Supabase.instance.client;

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
        description: e.description,
      );
    }
  }

  // 사용자 업데이트.
  @override
  Future<FortuneUserEntity> updateUser(RequestFortuneUser request) async {
    try {
      final user = await findUserByPhoneNonNull();
      return await _userService.update(
        user,
        request: request,
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
      // 테스트 계정 때문에 아이디 찾아야 됨.
      final imagePath = await _userService.getUpdateProfileFileUrl(filePath: filePath);
      return await updateUser(RequestFortuneUser(profileImage: imagePath));
    } on FortuneFailure catch (e) {
      throw e.handleFortuneFailure(
        description: FortuneTr.notUpdateUser,
      );
    }
  }

  @override
  Future<void> withdrawal() async {
    try {
      final user = await findUserByPhoneNonNull();
      await _userService.update(
        user,
        request: RequestFortuneUser(
          withdrawalAt: DateTime.now().toUtc().toIso8601String(),
          isWithdrawal: true,
        ),
      );
      await supabaseClient.auth.signOut();
    } on FortuneFailure catch (e) {
      throw e.handleFortuneFailure(
        description: FortuneTr.notUpdateUser,
      );
    }
  }

  // signOut() 처리되었기 때문에 로그인 후에 수행해야 함.
  @override
  Future<void> cancelWithdrawal() async {
    try {
      final user = await findUserByPhoneNonNull();
      await _userService.update(
        user,
        request: RequestFortuneUser(
          withdrawalAt: '',
          isWithdrawal: false,
        ),
        isCancelWithdrawal: true,
      );
    } on FortuneFailure catch (e) {
      throw e.handleFortuneFailure(
        description: FortuneTr.notUpdateUser,
      );
    }
  }
}
