import 'ingredient_entity.dart';
import 'normal_mission_entity.dart';

class MissionNormalClearConditionEntity {
  final int id;
  final MissionNormalEntity mission;
  final IngredientEntity ingredient;
  final int count;

  MissionNormalClearConditionEntity({
    required this.id,
    required this.mission,
    required this.count,
    required this.ingredient,
  });
}
