import 'package:foresh_flutter/data/supabase/response/eventnotice/event_rewards_response.dart';
import 'package:foresh_flutter/data/supabase/service/service_ext.dart';
import 'package:foresh_flutter/domain/supabase/entity/eventnotice/event_notices_response.dart';
import 'package:foresh_flutter/domain/supabase/entity/eventnotice/event_rewards_entity.dart';
import 'package:foresh_flutter/domain/supabase/entity/fortune_user_entity.dart';
import 'package:foresh_flutter/presentation/fortune_router.dart';
import 'package:json_annotation/json_annotation.dart';

import '../fortune_user_response.dart';

part 'event_notices_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class EventNoticesResponse extends EventNoticesEntity {
  @JsonKey(name: 'id')
  final double id_;
  @JsonKey(name: 'type')
  final String type_;
  @JsonKey(name: 'users')
  final FortuneUserResponse? users_;
  @JsonKey(name: 'event_rewards')
  final EventRewardsResponse? eventRewards_;
  @JsonKey(name: 'headings')
  final String headings_;
  @JsonKey(name: 'content')
  final String content_;
  @JsonKey(name: 'search_text')
  final String? searchText_;
  @JsonKey(name: 'landing_route')
  final String? landingRoute_;
  @JsonKey(name: 'created_at')
  final String createdAt_;
  @JsonKey(name: 'is_read')
  final bool isRead_;
  @JsonKey(name: 'is_receive')
  final bool isReceived_;

  EventNoticesResponse({
    required this.users_,
    required this.createdAt_,
    required this.id_,
    required this.searchText_,
    required this.headings_,
    required this.content_,
    required this.eventRewards_,
    required this.type_,
    required this.landingRoute_,
    required this.isRead_,
    required this.isReceived_,
  }) : super(
          id: id_.toInt(),
          type: getEventNoticeType(type_),
          user: users_ ?? FortuneUserEntity.empty(),
          eventReward: eventRewards_ ?? EventRewardsEntity.empty(),
          searchText: searchText_ ?? '',
          landingRoute: landingRoute_ ?? Routes.obtainHistoryRoute,
          createdAt: createdAt_,
          headings: headings_,
          content: content_,
          isRead: isRead_,
          isReceive: isReceived_,
        );

  factory EventNoticesResponse.fromJson(Map<String, dynamic> json) => _$EventNoticesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$EventNoticesResponseToJson(this);
}
