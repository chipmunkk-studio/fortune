import 'package:dartz/dartz.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/core/util/usecase.dart';
import 'package:fortune/domain/local/local_respository.dart';
import 'package:fortune/domain/supabase/repository/auth_repository.dart';
import 'package:fortune/domain/supabase/repository/user_repository.dart';
import 'package:fortune/domain/supabase/request/request_sign_up_or_in_test_param.dart';

class SignUpOrInWithTestUseCase implements UseCase1<void, RequestSignUpOrInTestParam> {
  final AuthRepository authRepository;
  final UserRepository userRepository;
  final LocalRepository localRepository;

  SignUpOrInWithTestUseCase({
    required this.authRepository,
    required this.userRepository,
    required this.localRepository,
  });

  @override
  Future<FortuneResult<void>> call(RequestSignUpOrInTestParam param) async {
    try {
      final user = await userRepository.findUserByPhone(param.testPhoneNumber);
      if (user != null) {
        await authRepository.signInWithEmail(
          email: param.testEmail,
          password: param.testPassword,
        );
      } else {
        await authRepository.signUpWithEmail(
          phoneNumber: param.testPhoneNumber,
          email: param.testEmail,
          password: param.testPassword,
        );
      }
      await localRepository.setTestAccount(param.testPhoneNumber);
      return const Right(null);
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }
}
