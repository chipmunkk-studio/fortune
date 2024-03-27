import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:fortune/domain/entity/mission_marker_entity.dart';
import 'package:fortune/presentation-v2/missiondetail/component/markerlayout/item_marker_layout.dart';

import 'one_marker_layout.dart';

class TwoMarkerLayout extends StatelessWidget {
  final MissionMarkerEntity one;
  final MissionMarkerEntity two;

  const TwoMarkerLayout(
    this.one,
    this.two, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OneMarkerLayout(one),
        const SizedBox(width: 26),
        OneMarkerLayout(two),
      ],
    );
  }
}