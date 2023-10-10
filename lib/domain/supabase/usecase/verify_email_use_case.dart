import 'package:dartz/dartz.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/core/util/usecase.dart';
import 'package:fortune/domain/supabase/entity/verify_phone_number_entity.dart';
import 'package:fortune/domain/supabase/repository/auth_repository.dart';
import 'package:fortune/domain/supabase/repository/user_repository.dart';
import 'package:fortune/domain/supabase/request/request_verify_phone_number_param.dart';

class VerifyEmailUseCase implements UseCase1<VerifyPhoneNumberEntity, RequestVerifyEmailParam> {
  final AuthRepository authRepository;
  final UserRepository userRepository;

  VerifyEmailUseCase({
    required this.authRepository,
    required this.userRepository,
  });

  @override
  Future<FortuneResult<VerifyPhoneNumberEntity>> call(RequestVerifyEmailParam request) async {
    try {
      final authResponse = await authRepository.verifyOTP(request);
      final userEntity = await userRepository.findUserByEmailNonNull();
      return Right(
        VerifyPhoneNumberEntity(
          authResponse: authResponse,
          userEntity: userEntity,
        ),
      );
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }
}
