import 'mission_card_entity.dart';

class MissionEntity {
  final int totalMarkerCount;
  final List<MissionCardEntity> missions;

  MissionEntity({
    required this.totalMarkerCount,
    required this.missions,
  });
}
