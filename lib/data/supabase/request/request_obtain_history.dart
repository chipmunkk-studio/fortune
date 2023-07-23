import 'package:json_annotation/json_annotation.dart';

part 'request_obtain_history.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class RequestObtainHistory {
  @JsonKey(name: 'ingredient')
  final int? ingredientId;
  @JsonKey(name: 'user')
  final int? userId;
  @JsonKey(name: 'marker_id')
  final int? markerId;
  @JsonKey(name: 'nickname')
  final String? nickName;
  @JsonKey(name: 'ingredient_name')
  final String? ingredientName;
  @JsonKey(name: 'kr_location_name')
  final String? krLocationName;
  @JsonKey(name: 'en_location_name')
  final String? enLocationName;
  @JsonKey(name: 'is_reward')
  final bool? isReward;

  RequestObtainHistory({
    this.ingredientId,
    this.userId,
    this.nickName,
    this.ingredientName,
    this.markerId,
    this.krLocationName,
    this.enLocationName,
    this.isReward,
  });

  RequestObtainHistory.insert({
    required this.ingredientId,
    required this.userId,
    required this.nickName,
    required this.ingredientName,
    this.markerId,
    this.krLocationName,
    this.enLocationName,
    this.isReward = false,
  });

  factory RequestObtainHistory.fromJson(Map<String, dynamic> json) => _$RequestObtainHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$RequestObtainHistoryToJson(this);
}
