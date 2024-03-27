import 'package:fortune/domain/entity/mission_marker_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'mission_marker_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class MissionMarkerResponse extends MissionMarkerEntity {
  @JsonKey(name: 'id')
  final String? id_;
  @JsonKey(name: 'name')
  final String? name_;
  @JsonKey(name: 'image_url')
  final String? imageUrl_;
  @JsonKey(name: 'required_count')
  final int? requiredCount_;
  @JsonKey(name: 'obtained_count')
  final int? obtainedCount_;

  MissionMarkerResponse({
    this.id_,
    this.name_,
    this.imageUrl_,
    this.requiredCount_,
    this.obtainedCount_,
  }) : super(
          id: id_ ?? '',
          name: name_ ?? '',
          imageUrl: imageUrl_ ?? '',
          requiredCount: requiredCount_ ?? 0,
          obtainedCount: obtainedCount_ ?? 0,
        );

  factory MissionMarkerResponse.fromJson(Map<String, dynamic> json) => _$MissionMarkerResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MissionMarkerResponseToJson(this);
}
