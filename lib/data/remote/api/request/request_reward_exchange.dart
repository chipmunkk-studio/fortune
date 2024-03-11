import 'package:json_annotation/json_annotation.dart';

part 'request_reward_exchange.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class RequestRewardExchange {
  @JsonKey(name: 'rewardId')
  final int rewardId;

  RequestRewardExchange({required this.rewardId});

  factory RequestRewardExchange.fromJson(Map<String, dynamic> json) => _$RequestRewardExchangeFromJson(json);

  Map<String, dynamic> toJson() => _$RequestRewardExchangeToJson(this);
}
