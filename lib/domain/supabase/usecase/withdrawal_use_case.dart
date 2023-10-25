import 'package:dartz/dartz.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/core/util/usecase.dart';
import 'package:fortune/domain/supabase/repository/user_repository.dart';

class WithdrawalUseCase implements UseCase1<void, String> {
  final UserRepository userRepository;

  WithdrawalUseCase({
    required this.userRepository,
  });

  @override
  Future<FortuneResult<void>> call(String param) async {
    try {
      await userRepository.withdrawal(param);
      return const Right(null);
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }
}
