import 'package:foresh_flutter/domain/supabase/entity/obtain_marker_entity.dart';

abstract class ObtainHistoryRepository {
  // 히스토리 목록 불러오기
  Future<List<ObtainHistoryEntity>> getAllHistories({
    int start = 0,
    int end = 19,
    String query = '',
  });

  // 히스토리 삽입.
  Future<void> insertObtainHistory({
    required int ingredientId,
    required int userId,
    required String markerId,
    required String krLocationName,
    required String enLocationName,
    required String krIngredientName,
    required String enIngredientName,
    required String nickname,
  });
}
