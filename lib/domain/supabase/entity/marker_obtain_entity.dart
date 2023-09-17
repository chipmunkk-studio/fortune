import 'package:fortune/domain/supabase/entity/fortune_user_entity.dart';

class MarkerObtainEntity {
  final FortuneUserEntity user;
  final String dialogHeadings;
  final String dialogContent;
  final bool isLevelOrGradeUp;
  final int haveCount;

  MarkerObtainEntity({
    required this.user,
    this.dialogHeadings = '',
    this.dialogContent = '',
    this.isLevelOrGradeUp = false,
    required this.haveCount,
  });
}
