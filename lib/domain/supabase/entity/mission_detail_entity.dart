import 'ingredient_entity.dart';
import 'mission_entity.dart';

class MissionDetailEntity {
  final List<MissionDetailViewItemEntity> markers;
  final MissionsEntity mission;
  final bool isEnableMissionClear;

  MissionDetailEntity({
    required this.markers,
    required this.mission,
  }) : isEnableMissionClear = markers.where((element) => !element.isConditionSatisfied).isEmpty;

  factory MissionDetailEntity.initial() => MissionDetailEntity(
        markers: [],
        mission: MissionsEntity.empty(),
      );
}

class MissionDetailViewItemEntity {
  final IngredientEntity ingredient;
  final int haveCount;
  final int requireCount;
  final bool isConditionSatisfied;
  final bool isEmpty;

  MissionDetailViewItemEntity({
    required this.ingredient,
    required this.haveCount,
    required this.requireCount,
    this.isEmpty = false,
  }) : isConditionSatisfied = haveCount >= requireCount;

  factory MissionDetailViewItemEntity.empty() {
    return MissionDetailViewItemEntity(
      ingredient: IngredientEntity.empty(),
      haveCount: 0,
      requireCount: 0,
      isEmpty: true,
    );
  }
}
