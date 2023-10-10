import 'package:dartz/dartz.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/core/util/usecase.dart';
import 'package:fortune/domain/supabase/entity/fortune_user_entity.dart';
import 'package:fortune/domain/supabase/repository/auth_repository.dart';
import 'package:fortune/domain/supabase/repository/user_repository.dart';

class GetCurrentUserUseCase implements UseCase0<FortuneUserEntity?> {
  final AuthRepository authRepository;
  final UserRepository userRepository;

  GetCurrentUserUseCase({
    required this.authRepository,
    required this.userRepository,
  });

  @override
  Future<FortuneResult<FortuneUserEntity?>> call() async {
    try {
      final user = await userRepository.findUserByEmailNonNull();
      return Right(user);
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }
}
