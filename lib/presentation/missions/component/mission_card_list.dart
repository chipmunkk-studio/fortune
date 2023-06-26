import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:foresh_flutter/presentation/missions/bloc/missions.dart';

import 'mission_normal_card.dart';

class MissionCardList extends StatelessWidget {
  final dartz.Function1<MissionsViewItem, void> onItemClick;
  final List<MissionsViewItem> missions;

  const MissionCardList({
    required this.missions,
    required this.onItemClick,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemCount: missions.length,
      separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 20),
      itemBuilder: (BuildContext context, int index) {
        final item = missions[index];
        return Bounceable(
          onTap: () => onItemClick(item),
          child: () {
            if (item is MissionNormalViewItem) {
              return MissionNormalCard(item);
            } else {
              return Container();
            }
          }(),
        );
      },
    );
  }
}
