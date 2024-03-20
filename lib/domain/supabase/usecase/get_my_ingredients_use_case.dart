import 'package:dartz/dartz.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/core/util/usecase.dart';
import 'package:fortune/data/supabase/response/fortune_user_response.dart';
import 'package:fortune/data/supabase/service_ext.dart';
import 'package:fortune/domain/supabase/entity/my_ingredients_view_entity.dart';
import 'package:fortune/domain/supabase/repository/ingredient_respository.dart';
import 'package:fortune/domain/supabase/repository/obtain_history_repository.dart';
import 'package:fortune/domain/supabase/repository/user_repository.dart';

class GetMyIngredientsUseCase implements UseCase0<MyIngredientsViewEntity> {
  final ObtainHistoryRepository obtainHistoryRepository;
  final IngredientRepository ingredientRepository;
  final UserRepository userRepository;

  GetMyIngredientsUseCase({
    required this.obtainHistoryRepository,
    required this.ingredientRepository,
    required this.userRepository,
  });

  @override
  Future<FortuneResultDeprecated<MyIngredientsViewEntity>> call() async {
    try {
      final ingredients = await ingredientRepository.findAllIngredients();
      final user = await userRepository.findUserByEmailNonNull(columnsToSelect: [UserColumn.id]);

      final sortedIngredients = ingredients
          .where(
            (element) => element.type != IngredientType.coin,
          )
          .toList()
        ..sort((a, b) {
          var order = [
            IngredientType.normal,
            IngredientType.unique,
            IngredientType.rare,
            IngredientType.epic,
            IngredientType.special,
          ];

          int indexA = order.indexOf(a.type);
          int indexB = order.indexOf(b.type);

          if (indexA == -1) indexA = order.length;
          if (indexB == -1) indexB = order.length;

          return indexA.compareTo(indexB);
        });

      final historiesFutures = sortedIngredients.map((e) async {
        final histories = await obtainHistoryRepository.getHistoriesByUserAndIngredient(
          userId: user.id,
          ingredientId: e.id,
        );
        return MyIngredientsViewListEntity(
          ingredient: e,
          histories: histories,
        );
      });

      final histories = (await Future.wait(historiesFutures)).where((element) => element.histories.isNotEmpty).toList();
      final totalCount = histories.isNotEmpty ? histories.map((e) => e.histories.length).reduce((a, b) => a + b) : 0;

      final entity = MyIngredientsViewEntity(
        histories: histories,
        totalCount: totalCount,
      );

      return Right(entity);
    } on FortuneFailureDeprecated catch (e) {
      return Left(e);
    }
  }
}
