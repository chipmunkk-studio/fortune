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
    required this.level,
  })  : percentageNextLevel = calculateLevelProgress(markerObtainCount),
        isGlobal = countryCode != '82',
        grade = getUserGradeIconInfo(assignGrade(level));

  FortuneUserEntity copyWith({
    int? id,
    String? phone,
    String? countryCode,
    String? nickname,
    String? profileImage,
    int? ticket,
    int? markerObtainCount,
    int? level,
  }) {
    return FortuneUserEntity(
      id: id ?? this.id,
      phone: phone ?? this.phone,
      countryCode: countryCode ?? this.countryCode,
      nickname: nickname ?? this.nickname,
      profileImage: profileImage ?? this.profileImage,
      ticket: ticket ?? this.ticket,
      markerObtainCount: markerObtainCount ?? this.markerObtainCount,
      level: level ?? this.level,
    );
  }

}
