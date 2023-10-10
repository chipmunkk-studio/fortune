import 'package:fortune/core/error/failure/common_failure.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/core/util/mixpanel.dart';
import 'package:fortune/data/local/datasource/local_datasource.dart';
import 'package:fortune/data/supabase/request/request_fortune_user.dart';
import 'package:fortune/data/supabase/service/user_service.dart';
import 'package:fortune/domain/supabase/entity/fortune_user_entity.dart';
import 'package:fortune/domain/supabase/repository/user_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserRepositoryImpl extends UserRepository {
  final UserService _userService;
  final LocalDataSource _localDataSource;
  final MixpanelTracker _mixpanelTracker;
  final _supabaseClient = Supabase.instance.client;

  UserRepositoryImpl(
    this._userService,
    this._localDataSource,
    this._mixpanelTracker,
  );

  // 휴대폰 번호로 현재 사용자 찾기.
  @override
  Future<FortuneUserEntity> findUserByEmailNonNull() async {
    try {
      final String currentEmail = Supabase.instance.client.auth.currentUser?.email ?? '';
      final FortuneUserEntity? user = await _userService.findUserByEmail(currentEmail);
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
  Future<FortuneUserEntity?> findUserByEmail(email) async {
    try {
      final FortuneUserEntity? user = await _userService.findUserByEmail(email);
      return user;
    } on FortuneFailure catch (e) {
      throw e.handleFortuneFailure(
        description: e.description,
      );
    }
  }

  // 사용자 업데이트.
  @override
  Future<FortuneUserEntity> updateUserTicket({
    required int ticket,
    required int markerObtainCount,
  }) async {
    try {
      final user = await findUserByEmailNonNull();
      return await _userService.update(
        user,
        request: RequestFortuneUser(
          ticket: ticket,
          markerObtainCount: markerObtainCount,
        ),
      );
    } on FortuneFailure catch (e) {
      throw e.handleFortuneFailure(
        description: FortuneTr.msgTicketUpdateFailed,
      );
    }
  }

  // 사용자 업데이트.
  @override
  Future<FortuneUserEntity> updateUserNickName({required String nickname}) async {
    try {
      final user = await findUserByEmailNonNull();
      return await _userService.update(
        user,
        request: RequestFortuneUser(
          nickname: nickname,
        ),
      );
    } on FortuneFailure catch (e) {
      throw e.handleFortuneFailure(
        description: FortuneTr.msgNicknameExists,
      );
    }
  }

  @override
  Future<FortuneUserEntity> updateUserProfile(String filePath) async {
    try {
      // 테스트 계정 때문에 아이디 찾아야 됨.
      final imagePath = await _userService.getUpdateProfileFileUrl(filePath: filePath);
      final user = await findUserByEmailNonNull();
      final result = await _userService.update(user, request: RequestFortuneUser(profileImage: imagePath));
      return result;
    } on FortuneFailure catch (e) {
      throw e.handleFortuneFailure(
        description: FortuneTr.notUpdateUser,
      );
    }
  }

  @override
  Future<void> withdrawal() async {
    try {
      final user = await findUserByEmailNonNull();
      await _userService.update(
        user,
        request: RequestFortuneUser(
          withdrawalAt: DateTime.now().toUtc().toIso8601String(),
          isWithdrawal: true,
        ),
      );
      await _supabaseClient.auth.signOut();
      _mixpanelTracker.trackEvent('회원 탈퇴', properties: {'phone': user.email});
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
      final user = await findUserByEmailNonNull();
      await _userService.update(
        user,
        request: RequestFortuneUser(
          withdrawalAt: '',
          isWithdrawal: false,
        ),
        isCancelWithdrawal: true,
      );
      _mixpanelTracker.trackEvent('회원 탈퇴 철회', properties: {'phone': user.email});
    } on FortuneFailure catch (e) {
      throw e.handleFortuneFailure(
        description: FortuneTr.notUpdateUser,
      );
    }
  }
}
