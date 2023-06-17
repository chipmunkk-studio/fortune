import 'ingredient_entity.dart';
import 'mission_entity.dart';

class MissionClearConditionEntity {
  final int id;
  final MissionEntity mission;
  final IngredientEntity ingredient;
  final int count;

  MissionClearConditionEntity({
    required this.id,
    required this.mission,
    required this.count,
    required this.ingredient,
  });
}
