import 'ingredient_entity.dart';
import 'mission_entity.dart';

class MissionClearConditionEntity {
  final int id;
  final MissionsEntity mission;
  final IngredientEntity ingredient;
  final int requireCount;

  MissionClearConditionEntity({
    required this.id,
    required this.mission,
    required this.requireCount,
    required this.ingredient,
  });
}
