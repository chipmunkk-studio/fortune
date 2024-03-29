import 'package:fortune/core/message_ext.dart';
import 'package:fortune/data/supabase/service_ext.dart';
import 'package:fortune/domain/supabase/entity/fortune_user_grade_entity.dart';
import 'package:json_annotation/json_annotation.dart';

import 'fortune_user_next_level_entity.dart';

part 'fortune_user_entity.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class FortuneUserEntity {
  final int id;
  final String email;
  final String nickname;
  final String profileImage;
  final String pushToken;
  final int ticket;
  final int markerObtainCount;
  final int level;
  final FortuneUserGradeEntity grade;
  final bool isWithdrawal;
  final String withdrawalAt;
  final String createdAt;
  final FortuneUserNextLevelEntity nextLevelInfo;

  FortuneUserEntity({
    required this.id,
    required this.email,
    required this.nickname,
    required this.profileImage,
    required this.ticket,
    required this.markerObtainCount,
    required this.pushToken,
    required this.level,
    required this.isWithdrawal,
    required this.withdrawalAt,
    required this.createdAt,
  })  : nextLevelInfo = calculateLevelInfo(markerObtainCount),
        grade = getUserGradeIconInfo(assignGrade(level));

  factory FortuneUserEntity.fromJson(Map<String, dynamic> json) => _$FortuneUserEntityFromJson(json);

  Map<String, dynamic> toJson() => _$FortuneUserEntityToJson(this);

  FortuneUserEntity copyWith({
    int? id,
    String? email,
    String? countryCode,
    String? nickname,
    String? profileImage,
    int? ticket,
    int? markerObtainCount,
    int? level,
    bool? isWithdrawal,
    String? withdrawalAt,
    String? createdAt,
    String? pushToken,
    String? locale,
  }) {
    return FortuneUserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      nickname: nickname ?? this.nickname,
      profileImage: profileImage ?? this.profileImage,
      ticket: ticket ?? this.ticket,
      markerObtainCount: markerObtainCount ?? this.markerObtainCount,
      pushToken: pushToken ?? this.pushToken,
      level: level ?? this.level,
      isWithdrawal: isWithdrawal ?? this.isWithdrawal,
      createdAt: createdAt ?? this.createdAt,
      withdrawalAt: withdrawalAt ?? this.withdrawalAt,
    );
  }

  factory FortuneUserEntity.empty() {
    return FortuneUserEntity(
      id: -1,
      email: '',
      nickname: FortuneTr.msgUnknownUser,
      profileImage: '',
      isWithdrawal: false,
      pushToken: '',
      createdAt: '',
      withdrawalAt: '',
      ticket: 0,
      markerObtainCount: 0,
      level: 0,
    );
  }
}
