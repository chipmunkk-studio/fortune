import 'package:dartz/dartz.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/core/util/usecase.dart';
import 'package:fortune/data/supabase/service_ext.dart';
import 'package:fortune/domain/supabase/entity/ingredient_entity.dart';
import 'package:fortune/domain/supabase/repository/ingredient_respository.dart';

class GetIngredientsByTypeUseCase implements UseCase1<List<IngredientEntity>, IngredientType> {
  final IngredientRepository ingredientRepository;

  GetIngredientsByTypeUseCase({
    required this.ingredientRepository,
  });

  @override
  Future<FortuneResult<List<IngredientEntity>>> call(IngredientType type) async {
    try {
      final ingredients = await ingredientRepository.findIngredientsByType(type);
      return Right(ingredients);
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }
}
