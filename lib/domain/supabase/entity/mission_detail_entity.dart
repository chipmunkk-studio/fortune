import 'ingredient_entity.dart';

class MissionDetailEntity {
  List<MissionDetailViewItemEntity> markers;
  bool isEnableMissionClear;
  int ingredientLength;

  MissionDetailEntity({
    required this.markers,
  })  : isEnableMissionClear = markers.where((element) => !element.isConditionSatisfied).isEmpty,
        ingredientLength = markers.length;

  factory MissionDetailEntity.initial() => MissionDetailEntity(
        markers: [],
      );
}

class MissionDetailViewItemEntity {
  final IngredientEntity ingredient;
  final int haveCount;
  final int requireCount;
  final bool isConditionSatisfied;

  MissionDetailViewItemEntity({
    required this.ingredient,
    required this.haveCount,
    required this.requireCount,
  }) : isConditionSatisfied = haveCount >= requireCount;
}
