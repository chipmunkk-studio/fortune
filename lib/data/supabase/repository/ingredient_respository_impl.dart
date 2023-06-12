import 'package:dartz/dartz.dart';
import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/core/util/logger.dart';
import 'package:foresh_flutter/core/util/usecase.dart';
import 'package:foresh_flutter/data/supabase/service/ingredient_service.dart';
import 'package:foresh_flutter/domain/supabase/entity/ingredient_entity.dart';
import 'package:foresh_flutter/domain/supabase/repository/ingredient_respository.dart';

class IngredientRepositoryImpl extends IngredientRepository {
  final IngredientService _ingredientService;

  IngredientRepositoryImpl(
    this._ingredientService,
  );

  // 맵에 뿌릴 재료들 찾기.
  @override
  Future<FortuneResult<List<IngredientEntity>>> getIngredients() async {
    try {
      final List<IngredientEntity> ingredients = await _ingredientService.findIngredients();
      return Right(ingredients);
    } on FortuneFailure catch (e) {
      FortuneLogger.error('errorCode: ${e.code}, errorMessage: ${e.message}');
      return Left(e);
    }
  }
}
