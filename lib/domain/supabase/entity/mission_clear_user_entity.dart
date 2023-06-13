
import 'fortune_user_entity.dart';
import 'mission_entity.dart';

class MissionClearUserEntity {
  final int id;
  final MissionEntity mission;
  final FortuneUserEntity user;
  final String email;
  final bool isReceive;
  final String createdAt;

  MissionClearUserEntity({
    required this.id,
    required this.createdAt,
    required this.isReceive,
    required this.mission,
    required this.user,
    required this.email,
  });
}
