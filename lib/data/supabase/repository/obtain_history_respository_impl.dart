import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/core/util/logger.dart';
import 'package:foresh_flutter/data/supabase/request/request_obtain_history_update.dart';
import 'package:foresh_flutter/data/supabase/service/obtain_history_service.dart';
import 'package:foresh_flutter/domain/supabase/entity/obtain_history_entity.dart';
import 'package:foresh_flutter/domain/supabase/repository/obtain_history_repository.dart';

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
    } on FortuneFailure catch (e) {
      FortuneLogger.error('errorCode: ${e.code}, errorMessage: ${e.message},');
      rethrow;
    }
  }

  // 마커 히스토리 삽입.
  @override
  Future<void> insertObtainHistory({
    required RequestObtainHistory request,
  }) async {
    try {
      await _obtainHistoryService.insert(request: request);
    } on FortuneFailure catch (e) {
      FortuneLogger.error('errorCode: ${e.code}, errorMessage: ${e.message}');
      rethrow;
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
    } on FortuneFailure catch (e) {
      FortuneLogger.error('errorCode: ${e.code}, errorMessage: ${e.message},');
      rethrow;
    }
  }

  @override
  Future<List<ObtainHistoryEntity>> getHistoriesByUser({required int userId}) async {
    try {
      final List<ObtainHistoryEntity> histories = await _obtainHistoryService.findObtainHistoryByUser(
        userId: userId,
      );
      return histories;
    } on FortuneFailure catch (e) {
      FortuneLogger.error('errorCode: ${e.code}, errorMessage: ${e.message},');
      rethrow;
    }
  }

  @override
  Future<void> delete({
    required List<ObtainHistoryEntity> histories,
  }) async {
    try {
      final result = await _obtainHistoryService.delete(histories.map((e) => e.id).toList());
      return result;
    } on FortuneFailure catch (e) {
      FortuneLogger.error('errorCode: ${e.code}, errorMessage: ${e.message},');
      rethrow;
    }
  }
}
