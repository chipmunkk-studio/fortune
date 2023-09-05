import 'package:dartz/dartz.dart';
import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/core/util/usecase.dart';
import 'package:foresh_flutter/domain/supabase/entity/my_ingredients_view_entity.dart';
import 'package:foresh_flutter/domain/supabase/repository/ingredient_respository.dart';
import 'package:foresh_flutter/domain/supabase/repository/obtain_history_repository.dart';
import 'package:foresh_flutter/domain/supabase/repository/user_repository.dart';

class GetMyIngredientsUseCase implements UseCase0<List<MyIngredientsViewEntity>> {
  final ObtainHistoryRepository obtainHistoryRepository;
  final IngredientRepository ingredientRepository;
  final UserRepository userRepository;

  GetMyIngredientsUseCase({
    required this.obtainHistoryRepository,
    required this.ingredientRepository,
    required this.userRepository,
  });

  @override
  Future<FortuneResult<List<MyIngredientsViewEntity>>> call() async {
    try {
      final ingredients = await ingredientRepository.findAllIngredients();
      final user = await userRepository.findUserByPhoneNonNull();

      final historiesFutures = ingredients.map((e) async {
        final histories = await obtainHistoryRepository.getHistoriesByUserAndIngredient(
          userId: user.id,
          ingredientId: e.id,
        );
        return MyIngredientsViewEntity(histories: histories);
      });

      final futures = await Future.wait(historiesFutures);
      return Right(futures);
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }
}
