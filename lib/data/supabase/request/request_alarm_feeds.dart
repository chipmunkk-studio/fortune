import 'package:json_annotation/json_annotation.dart';

part 'request_alarm_feeds.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class RequestAlarmFeeds {
  @JsonKey(name: 'type')
  final String? type;
  @JsonKey(name: 'users')
  final int? users;
  @JsonKey(name: 'alarm_reward_history')
  final int? alarmRewardHistory;
  @JsonKey(name: 'headings')
  final String? headings;
  @JsonKey(name: 'content')
  final String? content;
  @JsonKey(name: 'is_read')
  final bool? isRead;

  RequestAlarmFeeds({
    this.users,
    this.alarmRewardHistory,
    this.type,
    this.isRead,
    this.headings,
    this.content,
  });

  RequestAlarmFeeds.insert({
    this.users,
    this.alarmRewardHistory,
    required this.type,
    this.isRead = false,
    required this.headings,
    required this.content,
  });

  factory RequestAlarmFeeds.fromJson(Map<String, dynamic> json) => _$RequestAlarmFeedsFromJson(json);

  Map<String, dynamic> toJson() => _$RequestAlarmFeedsToJson(this);
}
