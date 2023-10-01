import 'package:fortune/domain/supabase/entity/fortune_user_entity.dart';

class MarkerObtainEntity {
  final FortuneUserEntity user;
  final int haveCount;

  MarkerObtainEntity({
    required this.user,
    required this.haveCount,
  });
}
