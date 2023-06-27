import 'package:dartz/dartz.dart';
import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/core/util/usecase.dart';
import 'package:foresh_flutter/domain/supabase/repository/obtain_history_repository.dart';
import 'package:foresh_flutter/domain/supabase/repository/user_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GetObtainCountUseCase implements UseCase1<int, int> {
  final ObtainHistoryRepository obtainHistoryRepository;
  final UserRepository userRepository;

  GetObtainCountUseCase({
    required this.obtainHistoryRepository,
    required this.userRepository,
  });

  @override
  Future<FortuneResult<int>> call(int userId) async {
    try {
      final user = await userRepository.findUserByPhone();
      final histories = await obtainHistoryRepository.getHistoriesByUser(userId: userId);
      return Right(histories.length);
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }
}
