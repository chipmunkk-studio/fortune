import 'package:dartz/dartz.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/core/util/usecase.dart';
import 'package:fortune/data/supabase/service_ext.dart';
import 'package:fortune/domain/supabase/entity/ingredient_entity.dart';
import 'package:fortune/domain/supabase/repository/ingredient_respository.dart';

class GetIngredientsByTypeUseCase implements UseCase1<List<IngredientEntity>, List<IngredientType>> {
  final IngredientRepository ingredientRepository;

  GetIngredientsByTypeUseCase({
    required this.ingredientRepository,
  });

  @override
  Future<FortuneResultDeprecated<List<IngredientEntity>>> call(List<IngredientType> types) async {
    try {
      final ingredients = await ingredientRepository.findIngredientsByType(types);
      return Right(ingredients);
    } on FortuneFailureDeprecated catch (e) {
      return Left(e);
    }
  }
}
