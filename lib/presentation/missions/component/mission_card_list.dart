import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:fortune/data/supabase/response/mission/mission_ext.dart';
import 'package:fortune/domain/supabase/entity/mission/mission_view_entity.dart';
import 'package:fortune/presentation/missions/component/mission_grade_card.dart';
import 'package:fortune/presentation/missions/component/mission_relay_card.dart';

import 'mission_normal_card.dart';

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
            switch (item.mission.type) {
              case MissionType.normal:
                return MissionNormalCard(item);
              case MissionType.grade:
                return MissionGradeCard(item);
              case MissionType.relay:
                return MissionRelayCard(item);
              default:
                return Container();
            }
          }(),
        );
      },
    );
  }
}
