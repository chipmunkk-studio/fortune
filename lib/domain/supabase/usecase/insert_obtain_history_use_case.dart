import 'package:dartz/dartz.dart';
import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/core/util/usecase.dart';
import 'package:foresh_flutter/domain/supabase/repository/obtain_history_repository.dart';
import 'package:foresh_flutter/domain/supabase/repository/user_repository.dart';
import 'package:foresh_flutter/domain/supabase/request/request_insert_history_param.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class InsertObtainHistoryUseCase implements UseCase1<int, RequestInsertHistoryParam> {
  final UserRepository userRepository;
  final ObtainHistoryRepository obtainHistoryRepository;

  InsertObtainHistoryUseCase({
    required this.obtainHistoryRepository,
    required this.userRepository,
  });

  @override
  Future<FortuneResult<int>> call(RequestInsertHistoryParam param) async {
    try {
      // 유저 정보 가져오기.
      final user = await userRepository.findUserByPhone();
      final response = await obtainHistoryRepository.insertObtainHistory(
        userId: param.userId,
        markerId: param.markerId,
        ingredientId: param.ingredientId,
        nickname: param.nickname,
        krLocationName: param.krLocationName,
        enLocationName: param.enLocationName,
        ingredientName: param.ingredientName,
      );
      final histories = await obtainHistoryRepository.getHistoriesByUser(userId: user.id);
      return Right(histories.length);
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }
}
