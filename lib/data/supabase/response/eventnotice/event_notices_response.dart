import 'package:foresh_flutter/data/supabase/response/eventnotice/event_reward_history_response.dart';
import 'package:foresh_flutter/data/supabase/service/service_ext.dart';
import 'package:foresh_flutter/domain/supabase/entity/eventnotice/event_notices_response.dart';
import 'package:foresh_flutter/domain/supabase/entity/eventnotice/event_rewards_history_entity.dart';
import 'package:foresh_flutter/domain/supabase/entity/fortune_user_entity.dart';
import 'package:json_annotation/json_annotation.dart';

import '../fortune_user_response.dart';

part 'event_notices_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class EventNoticesResponse extends EventNoticesEntity {
  @JsonKey(name: 'id')
  final double id_;
  @JsonKey(name: 'headings')
  final String headings_;
  @JsonKey(name: 'content')
  final String content_;
  @JsonKey(name: 'users')
  final FortuneUserResponse? users_;
  @JsonKey(name: 'type')
  final String type_;
  @JsonKey(name: 'event_reward_history')
  final EventRewardHistoryResponse? eventRewards_;
  @JsonKey(name: 'is_read')
  final bool isRead_;
  @JsonKey(name: 'created_at')
  final String createdAt_;

  EventNoticesResponse({
    required this.users_,
    required this.createdAt_,
    required this.id_,
    required this.headings_,
    required this.content_,
    required this.eventRewards_,
    required this.type_,
    required this.isRead_,
  }) : super(
          id: id_.toInt(),
          type: getEventNoticeType(type_),
          user: users_ ?? FortuneUserEntity.empty(),
          eventRewardHistory: eventRewards_ ?? EventRewardHistoryEntity.empty(),
          createdAt: createdAt_,
          headings: headings_,
          content: content_,
          isRead: isRead_,
        );

  factory EventNoticesResponse.fromJson(Map<String, dynamic> json) => _$EventNoticesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$EventNoticesResponseToJson(this);
}
