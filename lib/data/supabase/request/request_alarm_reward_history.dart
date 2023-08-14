import 'package:json_annotation/json_annotation.dart';

part 'request_alarm_reward_history.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class RequestAlarmRewardHistory {
  @JsonKey(name: 'users')
  final int? user;
  @JsonKey(name: 'alarm_reward_info')
  final int? alarmRewardInfo;
  @JsonKey(name: 'ingredients')
  final int? ingredients;
  @JsonKey(name: 'is_receive')
  final bool? isReceive;

  RequestAlarmRewardHistory({
    this.alarmRewardInfo,
    this.user,
    this.ingredients,
    this.isReceive,
  });

  RequestAlarmRewardHistory.insert({
    required this.alarmRewardInfo,
    required this.user,
    required this.ingredients,
    this.isReceive = false,
  });

  factory RequestAlarmRewardHistory.fromJson(Map<String, dynamic> json) => _$RequestAlarmRewardHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$RequestAlarmRewardHistoryToJson(this);
}
