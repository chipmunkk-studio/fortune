import 'ingredient_entity.dart';
import 'normal_mission_entity.dart';

class NormalMissionClearConditionEntity {
  final int id;
  final NormalMissionEntity mission;
  final IngredientEntity ingredient;
  final int count;

  NormalMissionClearConditionEntity({
    required this.id,
    required this.mission,
    required this.count,
    required this.ingredient,
  });
}
