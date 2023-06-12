import 'package:foresh_flutter/core/util/usecase.dart';
import 'package:foresh_flutter/domain/supabase/repository/marker_respository.dart';
import 'package:foresh_flutter/domain/supabase/repository/obtain_history_repository.dart';
import 'package:foresh_flutter/domain/supabase/request/request_insert_history_param.dart';

class InsertObtainHistoryUseCase implements UseCase1<void, RequestInsertHistoryParam> {
  final ObtainHistoryRepository obtainHistoryRepository;
  final MarkerRepository markerRepository;

  InsertObtainHistoryUseCase({
    required this.obtainHistoryRepository,
    required this.markerRepository,
  });

  @override
  Future<FortuneResult<void>> call(RequestInsertHistoryParam param) async {
    await markerRepository.hitMarker(int.parse(param.markerId)).then((value) => value.getOrElse(() {}));
    return await obtainHistoryRepository.insertObtainHistory(
      userId: param.userId,
      markerId: param.markerId,
      ingredientId: param.ingredientId,
      nickname: param.nickname,
      krLocationName: param.krLocationName,
      enLocationName: param.enLocationName,
      enIngredientName: param.enIngredientName,
      krIngredientName: param.krIngredientName,
    );
  }
}
