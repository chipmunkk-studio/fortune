import 'mission_entity.dart';

class MissionViewEntity {
  final MissionsEntity mission;
  final int userHaveCount;
  final int requiredTotalCount;

  MissionViewEntity({
    required this.mission,
    required this.userHaveCount,
    required this.requiredTotalCount,
  });
}
