import 'package:dartz/dartz.dart';
import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/core/util/logger.dart';
import 'package:foresh_flutter/core/util/usecase.dart';
import 'package:foresh_flutter/data/supabase/service/user_service.dart';
import 'package:foresh_flutter/domain/supabase/entity/user_entity.dart';

class UserRepository {
  final UserService _userService;

  UserRepository(
    this._userService,
  );

  // 사용자 찾기.
  Future<FortuneResult<UserEntity?>> findUserByPhone(phoneNumber) async {
    try {
      final UserEntity? user = await _userService.findUserByPhone(phoneNumber);
      return Right(user);
    } on FortuneFailure catch (e) {
      FortuneLogger.error(
        'errorCode: ${e.code}, '
        'errorMessage: ${e.message}, '
        'exposureMessage: ${e.description}',
      );
      return Left(e);
    }
  }
}
