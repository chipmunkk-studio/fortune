import 'package:fortune/domain/supabase/entity/fortune_user_entity.dart';
import 'package:fortune/domain/supabase/entity/ingredient_entity.dart';

import 'alarm_rewards_entity.dart';

class AlarmRewardHistoryEntity {
  final int id;
  final FortuneUserEntity user;
  final AlarmRewardInfoEntity alarmRewardInfo;
  final IngredientEntity ingredients;
  final bool isReceive;
  final String createdAt;

  AlarmRewardHistoryEntity({
    required this.id,
    required this.alarmRewardInfo,
    required this.user,
    required this.ingredients,
    required this.isReceive,
    required this.createdAt,
  });

  factory AlarmRewardHistoryEntity.empty() => AlarmRewardHistoryEntity(
        id: -1,
        alarmRewardInfo: AlarmRewardInfoEntity.empty(),
        user: FortuneUserEntity.empty(),
        ingredients: IngredientEntity.empty(),
        isReceive: true,
        createdAt: DateTime.now().toIso8601String(), // 현재 시간을 ISO8601 형식의 문자열로 변환
      );
}
