import 'package:foresh_flutter/data/supabase/service_ext.dart';
import 'package:foresh_flutter/domain/supabase/entity/fortune_user_grade_entity.dart';

class FortuneUserEntity {
  final int id;
  final String phone;
  final String countryCode;
  final String nickname;
  final String profileImage;
  final int ticket;
  final int markerObtainCount;
  final int trashObtainCount;
  final int level;
  final FortuneUserGradeEntity grade;
  final double percentageNextLevel;
  final bool isGlobal;

  FortuneUserEntity({
    required this.id,
    required this.phone,
    required this.countryCode,
    required this.nickname,
    required this.profileImage,
    required this.ticket,
    required this.markerObtainCount,
    required this.trashObtainCount,
    required this.level,
  })  : percentageNextLevel = calculateLevelProgress(markerObtainCount),
        isGlobal = countryCode != '82',
        grade = getUserGradeIconInfo(assignGrade(level));
}
