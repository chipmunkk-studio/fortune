import 'package:foresh_flutter/core/util/usecase.dart';
import 'package:foresh_flutter/domain/supabase/repository/obtain_history_repository.dart';
import 'package:foresh_flutter/domain/supabase/request/request_insert_history_param.dart';

class InsertObtainHistoryUseCase implements UseCase1<void, RequestInsertHistoryParam> {
  final ObtainHistoryRepository obtainHistoryRepository;

  InsertObtainHistoryUseCase({
    required this.obtainHistoryRepository,
  });

  @override
  Future<FortuneResult<void>> call(RequestInsertHistoryParam param) async {
    return await obtainHistoryRepository.insertObtainHistory(
      nickName: param.nickName,
      location: param.location,
      locationKr: param.locationKr,
      enIngredientName: param.enIngredientName,
      krIngredientName: param.krIngredientName,
      ingredientType: param.ingredientType,
      ingredientImage: param.ingredientImage,
    );
  }
}
