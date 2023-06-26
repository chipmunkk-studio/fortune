import 'ingredient_entity.dart';
import 'normal_mission_entity.dart';

class MissionNormalDetailEntity {
  final List<NormalMissionDetailViewItemEntity> markers;
  final MissionNormalEntity mission;
  final bool isEnableMissionClear;

  MissionNormalDetailEntity({
    required this.markers,
    required this.mission,
  }) : isEnableMissionClear = markers.where((element) => !element.isConditionSatisfied).isEmpty;

  factory MissionNormalDetailEntity.initial() => MissionNormalDetailEntity(
        markers: [],
        mission: MissionNormalEntity.empty(),
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
