import 'fortune_user_entity.dart';
import 'normal_mission_entity.dart';

class NormalMissionClearUserEntity {
  final int id;
  final NormalMissionEntity mission;
  final FortuneUserEntity user;
  final String email;
  final bool isReceive;
  final String createdAt;

  NormalMissionClearUserEntity({
    required this.id,
    required this.createdAt,
    required this.isReceive,
    required this.mission,
    required this.user,
    required this.email,
  });
}
