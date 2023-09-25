import 'package:dartz/dartz.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/core/util/usecase.dart';
import 'package:fortune/domain/supabase/entity/verify_phone_number_entity.dart';
import 'package:fortune/domain/supabase/repository/auth_repository.dart';
import 'package:fortune/domain/supabase/repository/user_repository.dart';
import 'package:fortune/domain/supabase/request/request_verify_phone_number_param.dart';
import 'package:supabase/supabase.dart';

class VerifyPhoneNumberUseCase implements UseCase1<VerifyPhoneNumberEntity, RequestVerifyPhoneNumberParam> {
  final AuthRepository authRepository;
  final UserRepository userRepository;

  VerifyPhoneNumberUseCase({
    required this.authRepository,
    required this.userRepository,
  });

  @override
  Future<FortuneResult<VerifyPhoneNumberEntity>> call(RequestVerifyPhoneNumberParam request) async {
    try {
      final authResponse = await authRepository.verifyPhoneNumber(request);
      final userEntity = await userRepository.findUserByPhoneNonNull();
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
