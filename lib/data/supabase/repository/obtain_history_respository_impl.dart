import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/data/supabase/request/request_obtain_history.dart';
import 'package:fortune/data/supabase/response/obtain_history_response.dart';
import 'package:fortune/data/supabase/service/obtain_history_service.dart';
import 'package:fortune/domain/supabase/entity/obtain_history_entity.dart';
import 'package:fortune/domain/supabase/repository/obtain_history_repository.dart';

class ObtainHistoryRepositoryImpl extends ObtainHistoryRepository {
  final ObtainHistoryService _obtainHistoryService;

  ObtainHistoryRepositoryImpl(
    this._obtainHistoryService,
  );

  // 모든 마커 히스토리 불러오기
  @override
  Future<List<ObtainHistoryEntity>> getAllHistories({
    int start = 0,
    int end = 19,
    String query = '',
  }) async {
    try {
      final List<ObtainHistoryEntity> histories = await _obtainHistoryService.findObtainHistories(
        start: start,
        end: end,
        query: query,
      );
      return histories;
    } on FortuneFailureDeprecated catch (e) {
      throw e.handleFortuneFailure();
    }
  }

  // 마커 히스토리 삽입.
  @override
  Future<void> insertObtainHistory({
    required RequestObtainHistory request,
  }) async {
    try {
      await _obtainHistoryService.insert(request: request);
    } on FortuneFailureDeprecated catch (e) {
      throw e.handleFortuneFailure();
    }
  }

  @override
  Future<List<ObtainHistoryEntity>> getHistoriesByUserAndIngredient({
    required int userId,
    required int ingredientId,
  }) async {
    try {
      final List<ObtainHistoryEntity> histories = await _obtainHistoryService.findObtainHistoryByUserAndIngredient(
        userId: userId,
        ingredientId: ingredientId,
      );
      return histories;
    } on FortuneFailureDeprecated catch (e) {
      throw e.handleFortuneFailure();
    }
  }

  @override
  Future<List<ObtainHistoryEntity>> getHistoriesByUser(
    userId, {
    required List<ObtainHistoryColumn> columnsToSelect,
  }) async {
    try {
      final List<ObtainHistoryEntity> histories = await _obtainHistoryService.findObtainHistoryByUser(
        userId,
        columnsToSelect: columnsToSelect,
      );
      return histories;
    } on FortuneFailureDeprecated catch (e) {
      throw e.handleFortuneFailure();
    }
  }

  @override
  Future<void> delete({
    required List<ObtainHistoryEntity> histories,
  }) async {
    try {
      final result = await _obtainHistoryService.delete(histories.map((e) => e.id).toList());
      return result;
    } on FortuneFailureDeprecated catch (e) {
      throw e.handleFortuneFailure();
    }
  }
}
