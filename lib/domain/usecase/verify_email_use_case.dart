import 'package:dartz/dartz.dart';
import 'package:fortune/core/util/usecase2.dart';
import 'package:fortune/data/error/fortune_app_failures.dart';
import 'package:fortune/domain/entity/verify_email_entity.dart';
import 'package:fortune/domain/repository/auth_normal_repository.dart';

class VerifyEmailUseCase implements UseCase2<VerifyEmailEntity, String, String> {
  final AuthNormalRepository authRepository;

  VerifyEmailUseCase({
    required this.authRepository,
  });

  @override
  Future<FortuneResult<VerifyEmailEntity>> call(
    String email,
    String code,
  ) async {
    try {
      final response = await authRepository.verifyEmail(
        email: email,
        code: code,
      );
      return Right(response);
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }
}
