import 'package:dartz/dartz.dart';
import 'package:fortune/data/error/fortune_error.dart';
import 'package:fortune/domain/entity/email_verify_code_entity.dart';
import 'package:fortune/domain/repository/auth_normal_repository.dart';

import '../../core/util/usecase2.dart';

class RequestEmailVerifyCodeUseCase implements UseCase1<EmailVerifyCodeEntity, String> {
  final AuthNormalRepository authRepository;

  RequestEmailVerifyCodeUseCase({
    required this.authRepository,
  });

  @override
  Future<FortuneResult<EmailVerifyCodeEntity>> call(
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
