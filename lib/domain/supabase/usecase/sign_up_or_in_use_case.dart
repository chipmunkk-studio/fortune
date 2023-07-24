import 'package:dartz/dartz.dart';
import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/core/util/logger.dart';
import 'package:foresh_flutter/core/util/usecase.dart';
import 'package:foresh_flutter/domain/supabase/entity/fortune_user_entity.dart';
import 'package:foresh_flutter/domain/supabase/repository/auth_repository.dart';
import 'package:foresh_flutter/domain/supabase/repository/user_repository.dart';
import 'package:foresh_flutter/domain/supabase/request/request_verify_phone_number_param.dart';
import 'package:supabase/supabase.dart';

class SignUpOrInUseCase implements UseCase1<void, String> {
  final AuthRepository authRepository;
  final UserRepository userRepository;

  SignUpOrInUseCase({
    required this.authRepository,
    required this.userRepository,
  });

  @override
  Future<FortuneResult<void>> call(String phoneNumber) async {
    try {
      final user = await userRepository.findUserByPhone(phoneNumber.replaceFirst('+', ''));
      if (user != null) {
        FortuneLogger.info("가입 된 사용자");
        authRepository.signInWithOtp(phoneNumber: phoneNumber);
      } else {
        FortuneLogger.info("가입 되지 않은 사용자");
        authRepository.signUp(phoneNumber: phoneNumber);
      }
      return const Right(null);
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }
}
