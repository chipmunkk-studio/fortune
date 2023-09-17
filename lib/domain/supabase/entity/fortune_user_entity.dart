import 'package:fortune/data/supabase/service/service_ext.dart';
import 'package:fortune/domain/supabase/entity/fortune_user_grade_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'fortune_user_next_level_entity.dart';

part 'fortune_user_entity.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class FortuneUserEntity {
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'phone')
  final String phone;
  @JsonKey(name: 'nickname')
  final String nickname;
  @JsonKey(name: 'profileImage')
  final String profileImage;
  @JsonKey(name: 'ticket')
  final int ticket;
  @JsonKey(name: 'markerObtainCount')
  final int markerObtainCount;
  @JsonKey(name: 'level')
  final int level;
  @JsonKey(name: 'grade')
  final FortuneUserGradeEntity grade;
  @JsonKey(name: 'nextLevelInfo')
  final FortuneUserNextLevelEntity nextLevelInfo;

  FortuneUserEntity({
    required this.id,
    required this.phone,
    required this.nickname,
    required this.profileImage,
    required this.ticket,
    required this.markerObtainCount,
    required this.level,
  })  : nextLevelInfo = calculateLevelInfo(markerObtainCount),
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

  factory FortuneUserEntity.fromJson(Map<String, dynamic> json) => _$FortuneUserEntityFromJson(json);

  Map<String, dynamic> toJson() => _$FortuneUserEntityToJson(this);
}
