import '../fortune_user_entity.dart';
import 'missions_entity.dart';

class MissionClearUserHistoriesEntity {
  final MissionsEntity mission;
  final FortuneUserEntity user;
  final String createdAt;

  MissionClearUserHistoriesEntity({
    required this.createdAt,
    required this.mission,
    required this.user,
  });
}
