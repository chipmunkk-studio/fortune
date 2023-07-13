import 'package:foresh_flutter/presentation/fortune_router.dart';
import 'package:json_annotation/json_annotation.dart';

part 'request_event_notices.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class RequestEventNotices {
  @JsonKey(name: 'type')
  final String? type;
  @JsonKey(name: 'users')
  final int? users;
  @JsonKey(name: 'event_rewards')
  final int? eventRewards;
  @JsonKey(name: 'search_text')
  final String? searchText;
  @JsonKey(name: 'landing_route')
  final String? landingRoute;
  @JsonKey(name: 'headings')
  final String? headings;
  @JsonKey(name: 'content')
  final String? content;
  @JsonKey(name: 'is_read')
  final bool? isRead;
  @JsonKey(name: 'is_receive')
  final bool? isReceived;

  RequestEventNotices({
    this.users,
    this.searchText,
    this.eventRewards,
    this.type,
    this.landingRoute,
    this.isRead,
    this.isReceived,
    this.headings,
    this.content,
  });

  RequestEventNotices.insert({
    this.users,
    this.searchText = '',
    this.eventRewards,
    this.landingRoute = Routes.obtainHistoryRoute,
    required this.type,
    this.isRead = false,
    this.isReceived = false,
    required this.headings,
    required this.content,
  });

  factory RequestEventNotices.fromJson(Map<String, dynamic> json) => _$RequestEventNoticesFromJson(json);

  Map<String, dynamic> toJson() => _$RequestEventNoticesToJson(this);
}
