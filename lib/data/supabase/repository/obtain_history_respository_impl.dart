import 'package:dartz/dartz.dart';
import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/core/util/logger.dart';
import 'package:foresh_flutter/core/util/usecase.dart';
import 'package:foresh_flutter/data/supabase/service/obtain_history_service.dart';
import 'package:foresh_flutter/domain/supabase/entity/obtain_marker_entity.dart';
import 'package:foresh_flutter/domain/supabase/repository/obtain_history_repository.dart';

class ObtainHistoryRepositoryImpl extends ObtainHistoryRepository {
  final ObtainHistoryService _obtainHistoryService;

  ObtainHistoryRepositoryImpl(
    this._obtainHistoryService,
  );

  // 모든 마커 히스토리 불러오기
  @override
  Future<FortuneResult<List<ObtainHistoryEntity>>> getAllHistories(double? latitude, double? longitude) async {
    try {
      final List<ObtainHistoryEntity> histories = await _obtainHistoryService.findObtainHistories();
      return Right(histories);
    } on FortuneFailure catch (e) {
      FortuneLogger.error('errorCode: ${e.code}, errorMessage: ${e.message},');
      return Left(e);
    }
  }

  // 마커 히스토리 삽입.
  @override
  Future<FortuneResult<void>> insertObtainHistory({
    required String nickName,
    required String enIngredientName,
    required String krIngredientName,
    required String ingredientImage,
    required String ingredientType,
    required String location,
    required String locationKr,
  }) async {
    try {
      final result = await _obtainHistoryService.insert(
        nickname: nickName,
        enIngredientName: enIngredientName,
        krIngredientName: krIngredientName,
        ingredientImage: ingredientImage,
        ingredientType: ingredientType,
        location: location,
        locationKr: locationKr,
      );
      return Right(result);
    } on FortuneFailure catch (e) {
      FortuneLogger.error('errorCode: ${e.code}, errorMessage: ${e.message}');
      return Left(e);
    }
  }
}
