import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:foresh_flutter/data/supabase/response/mission/mission_ext.dart';
import 'package:foresh_flutter/domain/supabase/entity/mission/mission_view_entity.dart';
import 'package:foresh_flutter/presentation/missions/component/mission_relay_card.dart';

import 'mission_normal_card.dart';

class MissionCardList extends StatelessWidget {
  final dartz.Function1<MissionViewEntity, void> onItemClick;
  final List<MissionViewEntity> missions;

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
            switch (item.mission.missionType) {
              case MissionType.normal:
                return MissionNormalCard(item);
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
