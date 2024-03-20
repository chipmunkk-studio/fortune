import 'package:dartz/dartz.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/core/util/usecase.dart';
import 'package:fortune/domain/supabase/entity/fortune_user_entity.dart';
import 'package:fortune/domain/supabase/repository/auth_repository.dart';
import 'package:fortune/domain/supabase/repository/user_repository.dart';

class GetUserUseCase implements UseCase1<FortuneUserEntity?, String> {
  final AuthRepository authRepository;
  final UserRepository userRepository;

  GetUserUseCase({
    required this.authRepository,
    required this.userRepository,
  });

  @override
  Future<FortuneResultDeprecated<FortuneUserEntity?>> call(String email) async {
    try {
      final user = await userRepository.findUserByEmail(email);
      return Right(user);
    } on FortuneFailureDeprecated catch (e) {
      return Left(e);
    }
  }
}
