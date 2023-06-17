import 'package:foresh_flutter/domain/supabase/entity/obtain_history_entity.dart';

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
    required String ingredientName,
    required String nickname,
  });

  // 사용자 아이디와 재료 아이디로 조회.
  Future<List<ObtainHistoryEntity>> getHistoriesByUserAndIngredient({
    required int userId,
    required int ingredientId,
  });

  // 사용자 아이디로 조회.
  Future<List<ObtainHistoryEntity>> getHistoriesByUser({
    required int userId,
  });

  // 히스토리 삭제.
  Future<void> delete({
    required List<ObtainHistoryEntity> histories,
  });
}
