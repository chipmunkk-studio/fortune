import 'package:flutter/material.dart';
import 'package:fortune/domain/entity/mission_marker_entity.dart';
import 'package:fortune/presentation-v2/missiondetail/component/markerlayout/item_marker_layout.dart';

import 'one_marker_layout.dart';

class ThreeMarkerLayout extends StatelessWidget {
  final MissionMarkerEntity one;
  final MissionMarkerEntity two;
  final MissionMarkerEntity three;

  const ThreeMarkerLayout(
    this.one,
    this.two,
    this.three, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        OneMarkerLayout(one),
        const SizedBox(width: 26),
        OneMarkerLayout(two),
        const SizedBox(width: 26),
        OneMarkerLayout(three),
        const Spacer(),
      ],
    );
  }
}
