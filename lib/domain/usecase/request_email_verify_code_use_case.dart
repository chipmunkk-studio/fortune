import 'package:dartz/dartz.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/core/util/usecase.dart';
import 'package:fortune/domain/supabase/repository/auth_repository.dart';
import 'package:fortune/domain/supabase/request/request_sign_up_or_in_test_param.dart';

class RequestEmailVerifyCodeUseCase implements UseCase1<void, RequestSignUpOrInTestParam> {
  final AuthRepository authRepository;

  RequestEmailVerifyCodeUseCase({
    required this.authRepository,
  });

  @override
  Future<FortuneResult<void>>  call(RequestSignUpOrInTestParam param) async {
    try {
      // final user = await authRepository.signInWithOtp(phoneNumber: phoneNumber);
      return const Right(null);
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }
}
