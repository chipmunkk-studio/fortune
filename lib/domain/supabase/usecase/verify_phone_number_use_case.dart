import 'package:dartz/dartz.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/core/util/usecase.dart';
import 'package:fortune/domain/supabase/repository/auth_repository.dart';
import 'package:fortune/domain/supabase/request/request_verify_phone_number_param.dart';
import 'package:supabase/supabase.dart';

class VerifyPhoneNumberUseCase implements UseCase1<AuthResponse, RequestVerifyPhoneNumberParam> {
  final AuthRepository authRepository;

  VerifyPhoneNumberUseCase({
    required this.authRepository,
  });

  @override
  Future<FortuneResult<AuthResponse>> call(RequestVerifyPhoneNumberParam request) async {
    try {
      final user = await authRepository.verifyPhoneNumber(request);
      return Right(user);
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }
}
