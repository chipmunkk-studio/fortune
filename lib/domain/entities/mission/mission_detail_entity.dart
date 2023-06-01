import 'description_entity.dart';
import 'recipe_entity.dart';

class MissionDetailEntity {
  final int id;
  final String name;
  final String imageUrl;
  final bool exchangeable;
  final List<RecipeEntity> recipes;
  final List<DescriptionEntity> descriptions;

  MissionDetailEntity({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.exchangeable,
    required this.recipes,
    required this.descriptions,
  });
}