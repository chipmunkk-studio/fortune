import 'package:dartz/dartz.dart';
import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/core/util/usecase.dart';
import 'package:foresh_flutter/domain/supabase/entity/fortune_user_entity.dart';
import 'package:foresh_flutter/domain/supabase/repository/auth_repository.dart';
import 'package:foresh_flutter/domain/supabase/repository/user_repository.dart';

class GetUserUseCase implements UseCase1<FortuneUserEntity?, String> {
  final AuthRepository authRepository;
  final UserRepository userRepository;

  GetUserUseCase({
    required this.authRepository,
    required this.userRepository,
  });

  @override
  Future<FortuneResult<FortuneUserEntity?>> call(String phoneNumber) async {
    try {
      final user = await userRepository.findUserByPhone(phoneNumber.replaceFirst('+', ''));
      return Right(user);
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }
}
