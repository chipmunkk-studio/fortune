import 'package:dartz/dartz.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/core/util/usecase.dart';
import 'package:fortune/data/supabase/service/service_ext.dart';
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
  Future<FortuneResult<MyIngredientsViewEntity>> call() async {
    try {
      final ingredients = await ingredientRepository.findAllIngredients();
      final user = await userRepository.findUserByPhoneNonNull();

      final sortedIngredients = ingredients
          .where(
            (element) => element.type != IngredientType.ticket,
          )
          .toList()
        ..sort((a, b) {
          if (a.type == IngredientType.unique && b.type != IngredientType.unique) {
            return 1; // unique는 뒤로 가도록
          } else if (a.type != IngredientType.unique && b.type == IngredientType.unique) {
            return -1; // non-unique는 앞으로 가도록
          }
          return 0; // 같으면 순서 변경 없음
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

      final histories = await Future.wait(historiesFutures);
      final totalCount = histories.map((e) => e.histories.length).reduce((a, b) => a + b);

      final entity = MyIngredientsViewEntity(
        histories: histories,
        totalCount: totalCount,
      );

      return Right(entity);
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }
}
