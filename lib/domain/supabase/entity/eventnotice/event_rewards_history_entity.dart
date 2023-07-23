import 'package:foresh_flutter/domain/supabase/entity/eventnotice/event_rewards_entity.dart';
import 'package:foresh_flutter/domain/supabase/entity/fortune_user_entity.dart';

class EventRewardHistoryEntity {
  final int id;
  final FortuneUserEntity user;
  final EventRewardInfoEntity eventRewardInfo;
  final String ingredientImage;
  final String ingredientName;
  final bool isReceive;
  final String createdAt;

  EventRewardHistoryEntity({
    required this.id,
    required this.eventRewardInfo,
    required this.user,
    required this.ingredientImage,
    required this.ingredientName,
    required this.isReceive,
    required this.createdAt,
  });

  factory EventRewardHistoryEntity.empty() => EventRewardHistoryEntity(
        id: -1,
        eventRewardInfo: EventRewardInfoEntity.empty(),
        user: FortuneUserEntity.empty(),
        ingredientImage: '',
        ingredientName: '',
        isReceive: true,
        createdAt: DateTime.now().toIso8601String(), // 현재 시간을 ISO8601 형식의 문자열로 변환
      );
}
