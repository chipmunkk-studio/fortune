
import 'package:json_annotation/json_annotation.dart';

part 'reward_marker_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class RewardMarkerResponse {
  @JsonKey(name: 'grade')
  final int? grade;
  @JsonKey(name: 'count')
  final String? count;
  @JsonKey(name: 'open')
  final bool? open;

  RewardMarkerResponse({
    required this.grade,
    required this.count,
    required this.open,
  });

  factory RewardMarkerResponse.fromJson(Map<String, dynamic> json) => _$RewardMarkerResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RewardMarkerResponseToJson(this);
}
