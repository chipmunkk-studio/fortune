import 'ingredient_entity.dart';
import 'mission_entity.dart';

class MissionClearConditionEntity {
  final int id;
  final MissionEntity mission;
  final IngredientEntity ingredient;
  final double count;
  final String title;
  final String subtitle;
  final String content;

  MissionClearConditionEntity({
    required this.id,
    required this.mission,
    required this.count,
    required this.title,
    required this.subtitle,
    required this.content,
    required this.ingredient,
  });
}
