import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:fortune/domain/entity/mission_entity.dart';

import 'card/mission_normal_card.dart';

class MissionCardList extends StatelessWidget {
  final dartz.Function1<MissionEntity, void> onItemClick;
  final List<MissionEntity> missions;

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
      // 스크롤러블 안에서는 true로 해야 함.
      shrinkWrap: true,
      padding: const EdgeInsets.only(bottom: 20),
      separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 20),
      itemBuilder: (BuildContext context, int index) {
        final item = missions[index];
        return Bounceable(
          onTap: () => onItemClick(item),
          child: () {
            return MissionNormalCard(item);
          }(),
        );
      },
    );
  }
}
