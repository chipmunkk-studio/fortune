import 'package:dartz/dartz.dart';
import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/core/util/logger.dart';
import 'package:foresh_flutter/core/util/usecase.dart';
import 'package:foresh_flutter/data/supabase/service/user_service.dart';
import 'package:foresh_flutter/domain/supabase/entity/fortune_user_entity.dart';
import 'package:foresh_flutter/domain/supabase/repository/user_repository.dart';

class UserRepositoryImpl extends UserRepository {
  final UserService _userService;

  UserRepositoryImpl(
    this._userService,
  );

  // 사용자 찾기.
  @override
  Future<FortuneUserEntity> findUserByPhone(phoneNumber) async {
    try {
      final FortuneUserEntity? user = await _userService.findUserByPhone(phoneNumber);
      if (user == null) {
        throw CommonFailure(errorMessage: '사용자가 존재하지 않습니다');
      }
      return user;
    } on FortuneFailure catch (e) {
      FortuneLogger.error('errorCode: ${e.code}, errorMessage: ${e.message}');
      rethrow;
    }
  }

  @override
  Future<FortuneResult<FortuneUserEntity?>> findUserByPhoneEither(phoneNumber) async {
    try {
      final FortuneUserEntity? user = await _userService.findUserByPhone(phoneNumber);
      return Right(user);
    } on FortuneFailure catch (e) {
      FortuneLogger.error('errorCode: ${e.code}, errorMessage: ${e.message}');
      return Left(e);
    }
  }

  @override
  Future<FortuneUserEntity> reduceTrash({
    required String phoneNumber,
    required int trashCount,
  }) async {
    try {
      final FortuneUserEntity user = await _userService.update(
        phoneNumber,
        trashObtainCount: trashCount,
      );
      return user;
    } on FortuneFailure catch (e) {
      FortuneLogger.error('errorCode: ${e.code}, errorMessage: ${e.message}');
      rethrow;
    }
  }
}
