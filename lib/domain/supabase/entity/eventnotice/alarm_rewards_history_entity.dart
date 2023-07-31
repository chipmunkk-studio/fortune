import 'package:foresh_flutter/domain/supabase/entity/fortune_user_entity.dart';

import 'alarm_rewards_entity.dart';

class AlarmRewardHistoryEntity {
  final int id;
  final FortuneUserEntity user;
  final AlarmRewardInfoEntity eventRewardInfo;
  final String ingredientImage;
  final String ingredientName;
  final bool isReceive;
  final String createdAt;

  AlarmRewardHistoryEntity({
    required this.id,
    required this.eventRewardInfo,
    required this.user,
    required this.ingredientImage,
    required this.ingredientName,
    required this.isReceive,
    required this.createdAt,
  });

  factory AlarmRewardHistoryEntity.empty() => AlarmRewardHistoryEntity(
        id: -1,
        eventRewardInfo: AlarmRewardInfoEntity.empty(),
        user: FortuneUserEntity.empty(),
        ingredientImage: '',
        ingredientName: '',
        isReceive: true,
        createdAt: DateTime.now().toIso8601String(), // 현재 시간을 ISO8601 형식의 문자열로 변환
      );
}
