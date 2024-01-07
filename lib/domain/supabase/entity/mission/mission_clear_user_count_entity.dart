import 'package:fortune/domain/supabase/entity/fortune_user_entity.dart';

class MissionClearUserCountEntity {
  final FortuneUserEntity user;
  final int clearCount;

  MissionClearUserCountEntity({
    required this.user,
    required this.clearCount,
  });
}
