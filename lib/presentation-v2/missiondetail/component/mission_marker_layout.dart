import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fortune/domain/entity/mission_marker_entity.dart';
import 'package:fortune/presentation-v2/missiondetail/component/markerlayout/one_marker_layout.dart';
import 'package:fortune/presentation-v2/missiondetail/component/markerlayout/three_marker_layout.dart';
import 'package:fortune/presentation-v2/missiondetail/component/markerlayout/two_marker_layout.dart';

class MissionMarkerLayout extends StatelessWidget {
  final List<MissionMarkerEntity> _viewItems;

  const MissionMarkerLayout(
    this._viewItems, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    switch (_viewItems.length) {
      case 1:
        return OneMarkerLayout(
          _viewItems[0],
        );
      case 2:
        return TwoMarkerLayout(
          _viewItems[0],
          _viewItems[1],
        );
      case 3:
        return ThreeMarkerLayout(
          _viewItems[0],
          _viewItems[1],
          _viewItems[2],
        );
      case 4:
        return Column(
          children: [
            TwoMarkerLayout(
              _viewItems[0],
              _viewItems[1],
            ),
            const SizedBox(height: 26),
            TwoMarkerLayout(
              _viewItems[2],
              _viewItems[3],
            ),
          ],
        );
      case 5:
        return Column(
          children: [
            TwoMarkerLayout(
              _viewItems[0],
              _viewItems[1],
            ),
            const SizedBox(height: 26),
            ThreeMarkerLayout(
              _viewItems[2],
              _viewItems[3],
              _viewItems[4],
            ),
          ],
        );
      case 6:
        return Column(
          children: [
            ThreeMarkerLayout(
              _viewItems[0],
              _viewItems[1],
              _viewItems[2],
            ),
            const SizedBox(height: 26),
            ThreeMarkerLayout(
              _viewItems[3],
              _viewItems[4],
              _viewItems[5],
            ),
          ],
        );
      case 7:
        return Column(
          children: [
            TwoMarkerLayout(
              _viewItems[0],
              _viewItems[1],
            ),
            const SizedBox(height: 26),
            ThreeMarkerLayout(
              _viewItems[2],
              _viewItems[3],
              _viewItems[4],
            ),
            const SizedBox(height: 26),
            TwoMarkerLayout(
              _viewItems[5],
              _viewItems[6],
            ),
          ],
        );
      default:
        return Container();
    }
  }
}
