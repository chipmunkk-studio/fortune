import 'package:json_annotation/json_annotation.dart';

part 'request_obtain_history_update.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class RequestObtainHistory {
  @JsonKey(name: 'ingredient')
  final int? ingredientId;
  @JsonKey(name: 'user')
  final int? userId;
  @JsonKey(name: 'marker_id')
  final String? markerId;
  @JsonKey(name: 'nickname')
  final String? nickName;
  @JsonKey(name: 'ingredient_name')
  final String? ingredientName;
  @JsonKey(name: 'kr_location_name')
  final String? krLocationName;
  @JsonKey(name: 'en_location_name')
  final String? enLocationName;

  RequestObtainHistory({
    required this.ingredientId,
    required this.userId,
    required this.nickName,
    required this.ingredientName,
    required this.markerId,
    required this.krLocationName,
    required this.enLocationName,
  });

  factory RequestObtainHistory.fromJson(Map<String, dynamic> json) => _$RequestObtainHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$RequestObtainHistoryToJson(this);
}
