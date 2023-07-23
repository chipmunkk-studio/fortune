import 'package:foresh_flutter/data/supabase/service/service_ext.dart';
import 'package:foresh_flutter/domain/supabase/entity/fortune_user_entity.dart';

import 'event_rewards_history_entity.dart';

class EventNoticesEntity {
  final int id;
  final EventNoticeType type;
  final FortuneUserEntity user;
  final EventRewardHistoryEntity eventRewardHistory;
  final String landingRoute;
  final String createdAt;
  final String headings;
  final String content;
  final bool isRead;

  EventNoticesEntity({
    required this.createdAt,
    required this.id,
    required this.type,
    required this.landingRoute,
    required this.user,
    required this.eventRewardHistory,
    required this.isRead,
    required this.content,
    required this.headings,
  });
}
