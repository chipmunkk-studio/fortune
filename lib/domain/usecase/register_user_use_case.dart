import 'package:dartz/dartz.dart';
import 'package:fortune/core/util/usecase2.dart';
import 'package:fortune/data/error/fortune_app_failures.dart';
import 'package:fortune/domain/entity/user_token_entity.dart';
import 'package:fortune/domain/repository/no_auth_repository.dart';

class RegisterUserUseCase implements UseCase2<UserTokenEntity, String, String?> {
  final NoAuthRepository noAuthRepository;

  RegisterUserUseCase({
    required this.noAuthRepository,
  });

  @override
  Future<FortuneResult<UserTokenEntity>> call(
    String signUpToken,
    String? inviteToken,
  ) async {
    try {
      final response = await noAuthRepository.register(
        signUpToken: signUpToken,
        inviteToken: inviteToken,
      );
      return Right(response);
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }
}
