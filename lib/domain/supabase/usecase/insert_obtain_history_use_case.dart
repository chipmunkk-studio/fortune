import 'package:dartz/dartz.dart';
import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/core/util/usecase.dart';
import 'package:foresh_flutter/data/supabase/service/service_ext.dart';
import 'package:foresh_flutter/domain/supabase/entity/obtain_history_entity.dart';
import 'package:foresh_flutter/domain/supabase/repository/obtain_history_repository.dart';
import 'package:foresh_flutter/domain/supabase/repository/user_repository.dart';
import 'package:foresh_flutter/domain/supabase/request/request_insert_history_param.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class InsertObtainHistoryUseCase implements UseCase1<List<ObtainHistoryEntity>?, RequestInsertHistoryParam> {
  final UserRepository userRepository;
  final ObtainHistoryRepository obtainHistoryRepository;

  InsertObtainHistoryUseCase({
    required this.obtainHistoryRepository,
    required this.userRepository,
  });

  @override
  Future<FortuneResult<List<ObtainHistoryEntity>?>> call(RequestInsertHistoryParam param) async {
    try {
      // 티켓이 아닐 경우에만 히스토리 추가.
      if (param.ingredientType != IngredientType.ticket) {
        await obtainHistoryRepository.insertObtainHistory(
          userId: param.userId,
          markerId: param.markerId,
          ingredientId: param.ingredientId,
          nickname: param.nickname,
          krLocationName: param.krLocationName,
          enLocationName: param.enLocationName,
          ingredientName: param.ingredientName,
        );
        final histories = await obtainHistoryRepository.getHistoriesByUser(userId: param.userId);
        return Right(histories);
      } else {
        // 티켓일 경우 빈 값을 리턴.
        return const Right(null);
      }
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }
}
