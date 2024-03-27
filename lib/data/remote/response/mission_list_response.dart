import 'package:fortune/domain/entity/mission_entity.dart';
import 'package:fortune/domain/entity/mission_list_entity.dart';
import 'package:json_annotation/json_annotation.dart';

import 'mission_response.dart';

part 'mission_list_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class MissionListResponse extends MissionListEntity {
  @JsonKey(name: 'list')
  final List<MissionResponse>? list_;

  MissionListResponse({this.list_})
      : super(
          list: list_?.map((e) => e).toList() ?? List.empty(),
        );

  factory MissionListResponse.fromJson(Map<String, dynamic> json) => _$MissionListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MissionListResponseToJson(this);
}
