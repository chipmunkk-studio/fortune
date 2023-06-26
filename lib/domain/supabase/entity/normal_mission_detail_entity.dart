import 'ingredient_entity.dart';
import 'normal_mission_entity.dart';

class NormalMissionDetailEntity {
  final List<NormalMissionDetailViewItemEntity> markers;
  final NormalMissionEntity mission;
  final bool isEnableMissionClear;

  NormalMissionDetailEntity({
    required this.markers,
    required this.mission,
  }) : isEnableMissionClear = markers.where((element) => !element.isConditionSatisfied).isEmpty;

  factory NormalMissionDetailEntity.initial() => NormalMissionDetailEntity(
        markers: [],
        mission: NormalMissionEntity.empty(),
      );
}

class NormalMissionDetailViewItemEntity {
  final IngredientEntity ingredient;
  final int haveCount;
  final int requireCount;
  final bool isConditionSatisfied;
  final bool isEmpty;

  NormalMissionDetailViewItemEntity({
    required this.ingredient,
    required this.haveCount,
    required this.requireCount,
    this.isEmpty = false,
  }) : isConditionSatisfied = haveCount >= requireCount;

  factory NormalMissionDetailViewItemEntity.empty() {
    return NormalMissionDetailViewItemEntity(
      ingredient: IngredientEntity.empty(),
      haveCount: 0,
      requireCount: 0,
      isEmpty: true,
    );
  }
}
