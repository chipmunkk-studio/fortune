import 'package:dartz/dartz.dart';
import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/core/util/usecase.dart';
import 'package:foresh_flutter/domain/supabase/entity/ingredient_entity.dart';
import 'package:foresh_flutter/domain/supabase/repository/ingredient_respository.dart';

class GetIngredientsUseCase implements UseCase0<List<IngredientEntity>> {
  final IngredientRepository ingredientRepository;

  GetIngredientsUseCase({
    required this.ingredientRepository,
  });

  @override
  Future<FortuneResult<List<IngredientEntity>>> call() async {
    try {
      final ingredientsList = await ingredientRepository.getIngredients().then((value) => value.getOrElse(() => List.empty()));
      return Right(ingredientsList);
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }
}
