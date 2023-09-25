import 'package:dartz/dartz.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/core/util/usecase.dart';
import 'package:fortune/domain/supabase/repository/user_repository.dart';

class CancelWithdrawalUseCase implements UseCase0<void> {
  final UserRepository userRepository;

  CancelWithdrawalUseCase({
    required this.userRepository,
  });

  @override
  Future<FortuneResult<void>> call() async {
    try {
      await userRepository.cancelWithdrawal();
      return const Right(null);
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }
}
