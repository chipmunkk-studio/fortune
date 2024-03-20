import 'package:dartz/dartz.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/core/util/usecase.dart';
import 'package:fortune/domain/entity/request_email_verify_code_entity.dart';
import 'package:fortune/domain/repository/auth_normal_repository.dart';

class RequestEmailVerifyCodeUseCase implements UseCase1<RequestEmailVerifyCodeEntity, String> {
  final AuthNormalRepository authRepository;

  RequestEmailVerifyCodeUseCase({
    required this.authRepository,
  });

  @override
  Future<FortuneResult<RequestEmailVerifyCodeEntity>> call(
    String email,
  ) async {
    try {
      final entity = await authRepository.requestEmailVerifyCode(email: email);
      return Right(entity);
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }
}
