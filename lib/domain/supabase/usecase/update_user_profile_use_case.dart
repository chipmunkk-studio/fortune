import 'package:dartz/dartz.dart';
import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/core/util/usecase.dart';
import 'package:foresh_flutter/domain/supabase/entity/fortune_user_entity.dart';
import 'package:foresh_flutter/domain/supabase/repository/user_repository.dart';

class UpdateUserProfileUseCase implements UseCase1<FortuneUserEntity, String> {
  final UserRepository userRepository;

  UpdateUserProfileUseCase({
    required this.userRepository,
  });

  @override
  Future<FortuneResult<FortuneUserEntity>> call(String filePath) async {
    try {
      final user = await userRepository.updateUserProfile(filePath);
      return Right(user);
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }
}
