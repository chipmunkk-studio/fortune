import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:foresh_flutter/data/supabase/service_ext.dart';
import 'package:foresh_flutter/domain/supabase/entity/mission_entity.dart';
import 'package:foresh_flutter/presentation/missions/bloc/missions.dart';

import 'mission_normal_card.dart';
import 'mission_relay_card.dart';

class MissionCardList extends StatelessWidget {
  final dartz.Function1<MissionEntity, void> onItemClick;
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
          onTap: () => onItemClick(item.mission),
          child: () {
            if (item.mission.type == MissionType.normal || item.mission.type == MissionType.trash) {
              return MissionNormalCard(item);
            } else {
              return MissionRelayCard(item);
            }
          }(),
        );
      },
    );
  }
}
