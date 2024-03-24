import 'package:fortune/domain/entity/level_info_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'level_info_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class LevelInfoResponse extends LevelInfoEntity {
  @JsonKey(name: 'level')
  final int? level_;
  @JsonKey(name: 'grade')
  final String? grade_;
  @JsonKey(name: 'current')
  final int? current_;
  @JsonKey(name: 'total')
  final int? total_;

  LevelInfoResponse({
    this.level_,
    this.grade_,
    this.current_,
    this.total_,
  }) : super(
          level: level_ ?? -1,
          grade: grade_ ?? '',
          current: current_ ?? 0,
          total: total_ ?? 0,
        );

  factory LevelInfoResponse.fromJson(Map<String, dynamic> json) => _$LevelInfoResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LevelInfoResponseToJson(this);
}
