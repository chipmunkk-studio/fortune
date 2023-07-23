import 'package:foresh_flutter/data/supabase/service/service_ext.dart';
import 'package:foresh_flutter/domain/supabase/entity/fortune_user_grade_entity.dart';

class FortuneUserEntity {
  final int id;
  final String phone;
  final String nickname;
  final String profileImage;
  final int ticket;
  final int markerObtainCount;
  final int level;
  final FortuneUserGradeEntity grade;
  final double percentageNextLevel;

  FortuneUserEntity({
    required this.id,
    required this.phone,
    required this.nickname,
    required this.profileImage,
    required this.ticket,
    required this.markerObtainCount,
    required this.level,
  })  : percentageNextLevel = calculateLevelProgress(markerObtainCount),
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
      nickname: nickname ?? this.nickname,
      profileImage: profileImage ?? this.profileImage,
      ticket: ticket ?? this.ticket,
      markerObtainCount: markerObtainCount ?? this.markerObtainCount,
      level: level ?? this.level,
    );
  }

  factory FortuneUserEntity.empty() {
    return FortuneUserEntity(
      id: -1,
      phone: '',
      nickname: '',
      profileImage: '',
      ticket: 0,
      markerObtainCount: 0,
      level: 0,
    );
  }

}
