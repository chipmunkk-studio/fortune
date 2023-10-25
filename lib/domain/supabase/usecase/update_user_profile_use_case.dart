import 'package:dartz/dartz.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/core/util/usecase.dart';
import 'package:fortune/domain/supabase/entity/fortune_user_entity.dart';
import 'package:fortune/domain/supabase/repository/user_repository.dart';
import 'package:fortune/domain/supabase/request/request_profile_update_param.dart';

class UpdateUserProfileUseCase implements UseCase1<FortuneUserEntity, RequestProfileUpdateParam> {
  final UserRepository userRepository;

  UpdateUserProfileUseCase({
    required this.userRepository,
  });

  @override
  Future<FortuneResult<FortuneUserEntity>> call(RequestProfileUpdateParam param) async {
    try {
      final user = await userRepository.updateUserProfile(
        param.email,
        filePath: param.profile,
      );
      return Right(user);
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }
}
