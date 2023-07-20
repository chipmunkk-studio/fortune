import '../fortune_user_entity.dart';
import 'missions_entity.dart';

class MissionClearUserEntity {
  final int id;
  final MissionsEntity mission;
  final FortuneUserEntity user;
  final bool isReceive;
  final String createdAt;

  MissionClearUserEntity({
    required this.id,
    required this.createdAt,
    required this.isReceive,
    required this.mission,
    required this.user,
  });
}
