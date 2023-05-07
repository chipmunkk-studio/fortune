import 'package:json_annotation/json_annotation.dart';

part 'reward_exchangeable_marker_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class RewardExchangeableMarkerResponse {
  @JsonKey(name: 'grade')
  final int? grade;
  @JsonKey(name: 'count')
  final int? count;
  @JsonKey(name: 'userHaveCount')
  final int? userHaveCount;

  RewardExchangeableMarkerResponse({
    required this.grade,
    required this.count,
    required this.userHaveCount,
  });

  factory RewardExchangeableMarkerResponse.fromJson(Map<String, dynamic> json) =>
      _$RewardExchangeableMarkerResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RewardExchangeableMarkerResponseToJson(this);
}
