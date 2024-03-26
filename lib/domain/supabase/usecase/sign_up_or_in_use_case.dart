import 'package:dartz/dartz.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/core/util/usecase.dart';
import 'package:fortune/domain/supabase/repository/auth_repository.dart';
import 'package:fortune/domain/supabase/repository/user_repository.dart';
import 'package:fortune/domain/supabase/request/request_sign_up_param.dart';
import 'package:fortune/env.dart';

class SignUpOrInUseCase implements UseCase1<bool, RequestSignUpParam> {
  final AuthRepository authRepository;
  final UserRepository userRepository;
  final Environment env;

  SignUpOrInUseCase({
    required this.authRepository,
    required this.userRepository,
    required this.env,
  });

  @override
  Future<FortuneResultDeprecated<bool>> call(RequestSignUpParam param) async {
    try {
      final user = await userRepository.findUserByEmail(param.email);
      final remoteConfig = env.remoteConfig;

      // 테스트 계정으로 로그인 할 경우.
      if (remoteConfig.testSignInEmail == param.email) {
        await authRepository.signInWithEmailWithTest(
          email: remoteConfig.testSignInEmail,
          password: remoteConfig.testSignInPassword,
          isRegistered: user != null,
        );
        // 테스트 게정 일 경우
        return const Right(true);
      }

      if (user != null) {
        await authRepository.signInWithEmail(email: param.email);
      } else {
        await authRepository.signUpWithEmail(email: param.email);
      }
      // 테스트 계정이 아닐 경우.
      return const Right(false);
    } on FortuneFailureDeprecated catch (e) {
      return Left(e);
    }
  }
}
