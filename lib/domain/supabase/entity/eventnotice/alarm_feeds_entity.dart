import 'package:foresh_flutter/data/supabase/service/service_ext.dart';
import 'package:foresh_flutter/domain/supabase/entity/fortune_user_entity.dart';

import 'alarm_rewards_history_entity.dart';

class AlarmFeedsEntity {
  final int id;
  final AlarmFeedType type;
  final FortuneUserEntity user;
  final AlarmRewardHistoryEntity reward;
  final String createdAt;
  final String headings;
  final String content;
  final bool isRead;
  final bool isReceive;

  AlarmFeedsEntity({
    required this.createdAt,
    required this.id,
    required this.type,
    required this.user,
    required this.reward,
    required this.isRead,
    required this.content,
    required this.headings,
  }) : isReceive = reward.isReceive;
}
