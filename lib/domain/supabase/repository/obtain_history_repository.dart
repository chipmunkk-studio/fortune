import 'package:foresh_flutter/core/util/usecase.dart';
import 'package:foresh_flutter/domain/supabase/entity/obtain_marker_entity.dart';

abstract class ObtainHistoryRepository {
  // 히스토리 목록 불러오기
  Future<FortuneResult<List<ObtainHistoryEntity>>> getAllHistories(
    double? latitude,
    double? longitude,
  );

  // 히스토리 삽입.
  Future<FortuneResult<void>> insertObtainHistory({
    required String nickName,
    required String krIngredientName,
    required String enIngredientName,
    required String ingredientImage,
    required String location,
    required String locationKr,
    required String ingredientType,
  });
}
