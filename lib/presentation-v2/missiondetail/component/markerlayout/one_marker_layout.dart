import 'package:flutter/material.dart';
import 'package:fortune/domain/entity/mission_marker_entity.dart';
import 'package:fortune/presentation-v2/missiondetail/component/markerlayout/item_marker_layout.dart';

class OneMarkerLayout extends StatelessWidget {
  final MissionMarkerEntity entity;

  const OneMarkerLayout(this.entity, {super.key});

  @override
  Widget build(BuildContext context) {
    return ItemMarkerLayout(
      imageUrl: entity.imageUrl,
      name: entity.name,
      shouldDim: entity.obtainedCount >= entity.requiredCount,
      obtainedCount: entity.obtainedCount,
      requiredCount: entity.requiredCount,
    );
  }
}
