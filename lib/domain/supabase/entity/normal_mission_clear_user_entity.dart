import 'fortune_user_entity.dart';
import 'normal_mission_entity.dart';

class MissionNormalClearUserEntity {
  final int id;
  final MissionNormalEntity mission;
  final FortuneUserEntity user;
  final String email;
  final bool isReceive;
  final String createdAt;

  MissionNormalClearUserEntity({
    required this.id,
    required this.createdAt,
    required this.isReceive,
    required this.mission,
    required this.user,
    required this.email,
  });
}
