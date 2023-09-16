import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:dartz/dartz.dart';
import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/core/util/usecase.dart';
import 'package:foresh_flutter/domain/local/local_respository.dart';
import 'package:foresh_flutter/domain/supabase/repository/auth_repository.dart';
import 'package:foresh_flutter/domain/supabase/repository/user_repository.dart';

class SignUpOrInUseCase implements UseCase1<void, String> {
  final AuthRepository authRepository;
  final UserRepository userRepository;
  final LocalRepository localRepository;

  SignUpOrInUseCase({
    required this.authRepository,
    required this.userRepository,
    required this.localRepository,
  });

  @override
  Future<FortuneResult<void>> call(String phoneNumber) async {
    try {
      final user = await userRepository.findUserByPhone(phoneNumber.replaceFirst('+', ''));
      if (user != null) {
        AppMetrica.reportEvent('가입된 사용자');
        authRepository.signInWithOtp(phoneNumber: phoneNumber);
      } else {
        AppMetrica.reportEvent('미가입 사용자');
        authRepository.signUp(phoneNumber: phoneNumber);
      }
      await localRepository.setVerifySmsTime();
      return const Right(null);
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }
}
