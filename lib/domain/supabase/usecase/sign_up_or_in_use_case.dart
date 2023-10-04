import 'package:dartz/dartz.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/core/util/usecase.dart';
import 'package:fortune/domain/local/local_respository.dart';
import 'package:fortune/domain/supabase/repository/auth_repository.dart';
import 'package:fortune/domain/supabase/repository/user_repository.dart';
import 'package:fortune/domain/supabase/request/request_sign_up_param.dart';

class SignUpOrInUseCase implements UseCase1<void, RequestSignUpParam> {
  final AuthRepository authRepository;
  final UserRepository userRepository;
  final LocalRepository localRepository;

  SignUpOrInUseCase({
    required this.authRepository,
    required this.userRepository,
    required this.localRepository,
  });

  @override
  Future<FortuneResult<void>> call(RequestSignUpParam param) async {
    try {
      final user = await userRepository.findUserByPhone(param.phoneNumber);
      if (user != null) {
        await authRepository.signInWithOtp(phoneNumber: param.phoneNumber);
      } else {
        await authRepository.signUp(
          phoneNumber: param.phoneNumber,
          countryInfoId: param.countryInfoId,
        );
      }
      await localRepository.setVerifySmsTime();
      return const Right(null);
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }
}
