import 'package:fortune/core/error/failure/common_failure.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/core/util/mixpanel.dart';
import 'package:fortune/data/supabase/request/request_fortune_user.dart';
import 'package:fortune/data/supabase/service/user_service.dart';
import 'package:fortune/domain/supabase/entity/fortune_user_entity.dart';
import 'package:fortune/domain/supabase/repository/user_repository.dart';
import 'package:fortune/domain/supabase/request/request_get_all_users_param.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserRepositoryImpl extends UserRepository {
  final UserService _userService;
  final MixpanelTracker _mixpanelTracker;
  final _supabaseClient = Supabase.instance.client;

  UserRepositoryImpl(
    this._userService,
    this._mixpanelTracker,
  );

  // 휴대폰 번호로 현재 사용자 찾기.
  @override
  Future<FortuneUserEntity> findUserByEmailNonNull({String? emailParam}) async {
    try {
      final String currentEmail = emailParam ?? Supabase.instance.client.auth.currentUser?.email ?? '';
      final FortuneUserEntity? user = await _userService.findUserByEmail(currentEmail);
      if (user == null) {
        throw CommonFailure(errorMessage: FortuneTr.msgNotExistUser);
      }
      return user;
    } on FortuneFailure catch (e) {
      throw e.handleFortuneFailure();
    }
  }

  // 사용자 찾기.
  @override
  Future<FortuneUserEntity?> findUserByEmail(email) async {
    try {
      final FortuneUserEntity? user = await _userService.findUserByEmail(email);
      return user;
    } on FortuneFailure catch (e) {
      throw e.handleFortuneFailure();
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
      throw e.handleFortuneFailure();
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
      throw e.handleFortuneFailure();
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
      throw e.handleFortuneFailure();
    }
  }

  // signOut() 처리되었기 때문에 로그인 후에 수행해야 함.
  @override
  Future<void> cancelWithdrawal(String email) async {
    try {
      final user = await findUserByEmailNonNull(emailParam: email);
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
      throw e.handleFortuneFailure();
    }
  }

  @override
  Future<List<FortuneUserEntity>> getAllUsers(RequestRankingParam param) async {
    try {
      final List<FortuneUserEntity> users = await _userService.getAllUsersByTicketCountOrder(
        start: param.start,
        end: param.end,
      );
      return users;
    } on FortuneFailure catch (e) {
      throw e.handleFortuneFailure();
    }
  }

  @override
  Future<String> getUserRanking(FortuneUserEntity user) async {
    try {
      final String ranking = await _userService.getUserRanking(user);
      return ranking;
    } on FortuneFailure catch (e) {
      throw e.handleFortuneFailure();
    }
  }
}
