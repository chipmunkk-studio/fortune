import 'package:foresh_flutter/domain/entities/marker/marker_grade_entity.dart';
import 'package:foresh_flutter/domain/entities/reward/reward_marker_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reward_marker_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class RewardMarkerResponse extends RewardMarkerEntity {
  @JsonKey(name: 'grade')
  final int? grade_;
  @JsonKey(name: 'count')
  final String? count_;
  @JsonKey(name: 'open')
  final bool? open_;

  RewardMarkerResponse({
    required this.grade_,
    required this.count_,
    required this.open_,
  }) : super(
          grade: getMarkerGradeIconInfo(grade_ ?? 0),
          count: count_ ?? "",
          open: open_ ?? false,
        );

  factory RewardMarkerResponse.fromJson(Map<String, dynamic> json) => _$RewardMarkerResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RewardMarkerResponseToJson(this);
}
