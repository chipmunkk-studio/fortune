import 'package:json_annotation/json_annotation.dart';

part 'request_event_reward_history.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class RequestEventRewardHistory {
  @JsonKey(name: 'users')
  final int? user;
  @JsonKey(name: 'event_reward_info')
  final int? eventRewardInfo;
  @JsonKey(name: 'ingredient_image')
  final String? ingredientImage;
  @JsonKey(name: 'ingredient_name')
  final String? ingredientName;

  RequestEventRewardHistory({
    this.eventRewardInfo,
    this.user,
    this.ingredientImage,
    this.ingredientName,
  });

  RequestEventRewardHistory.insert({
    required this.eventRewardInfo,
    required this.user,
    required this.ingredientImage,
    required this.ingredientName,
  });

  factory RequestEventRewardHistory.fromJson(Map<String, dynamic> json) => _$RequestEventRewardHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$RequestEventRewardHistoryToJson(this);
}
