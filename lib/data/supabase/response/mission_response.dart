import 'package:foresh_flutter/data/supabase/response/marker_response.dart';
import 'package:foresh_flutter/data/supabase/service_ext.dart';
import 'package:foresh_flutter/domain/supabase/entity/mission_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'mission_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class MissionResponse extends MissionEntity {
  @JsonKey(name: 'id')
  final double id_;
  @JsonKey(name: 'big_title')
  final String bigTitle_;
  @JsonKey(name: 'big_subtitle')
  final String bigSubtitle_;
  @JsonKey(name: 'detail_title')
  final String detailTitle_;
  @JsonKey(name: 'detail_subtitle')
  final String detailSubtitle_;
  @JsonKey(name: 'detail_content')
  final String detailContent_;
  @JsonKey(name: 'reward_count')
  final double rewardCount_;
  @JsonKey(name: 'remain_count')
  final double remainCount_;
  @JsonKey(name: 'reward_image')
  final String rewardImage_;
  @JsonKey(name: 'is_global')
  final bool isGlobal_;
  @JsonKey(name: 'marker')
  final MarkerResponse? marker_;
  @JsonKey(name: 'type')
  final String type_;

  MissionResponse({
    required this.id_,
    required this.bigTitle_,
    required this.bigSubtitle_,
    required this.rewardCount_,
    required this.remainCount_,
    required this.rewardImage_,
    required this.detailTitle_,
    required this.detailSubtitle_,
    required this.detailContent_,
    required this.marker_,
    required this.isGlobal_,
    required this.type_,
  }) : super(
          id: id_.toInt(),
          bigTitle: bigTitle_,
          bigSubtitle: bigSubtitle_,
          detailTitle: detailTitle_,
          detailSubtitle: detailSubtitle_,
          detailContent: detailContent_,
          remainCount: remainCount_.toInt(),
          rewardCount: rewardCount_.toInt(),
          marker: marker_,
          rewardImage: rewardImage_,
          type: getMissionType(type_),
          isGlobal: isGlobal_,
        );

  factory MissionResponse.fromJson(Map<String, dynamic> json) => _$MissionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MissionResponseToJson(this);
}
