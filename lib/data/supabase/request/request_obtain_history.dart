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
  @JsonKey(name: 'kr_ingredient_name')
  final String? krIngredientName;
  @JsonKey(name: 'en_ingredient_name')
  final String? enIngredientName;
  @JsonKey(name: 'location_name')
  final String? locationName;
  @JsonKey(name: 'is_reward')
  final bool? isReward;

  RequestObtainHistory({
    this.ingredientId,
    this.userId,
    this.nickName,
    this.krIngredientName,
    this.enIngredientName,
    this.markerId,
    this.locationName,
    this.isReward,
  });

  RequestObtainHistory.insert({
    this.ingredientId,
    required this.userId,
    required this.nickName,
    required this.krIngredientName,
    required this.enIngredientName,
    this.markerId,
    this.locationName,
    this.isReward = false,
  });

  factory RequestObtainHistory.fromJson(Map<String, dynamic> json) => _$RequestObtainHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$RequestObtainHistoryToJson(this);
}
