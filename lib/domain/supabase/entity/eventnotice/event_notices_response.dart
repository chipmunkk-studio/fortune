import 'package:foresh_flutter/data/supabase/service/service_ext.dart';
import 'package:foresh_flutter/domain/supabase/entity/eventnotice/event_rewards_entity.dart';
import 'package:foresh_flutter/domain/supabase/entity/fortune_user_entity.dart';

class EventNoticesEntity {
  final int id;
  final EventNoticeType type;
  final FortuneUserEntity user;
  final EventRewardsEntity eventReward;
  final String searchText;
  final String landingRoute;
  final String createdAt;
  final String headings;
  final String content;
  final bool isRead;
  final bool isReceive;

  EventNoticesEntity({
    required this.createdAt,
    required this.id,
    required this.searchText,
    required this.type,
    required this.landingRoute,
    required this.user,
    required this.eventReward,
    required this.isRead,
    required this.isReceive,
    required this.content,
    required this.headings,
  });
}
