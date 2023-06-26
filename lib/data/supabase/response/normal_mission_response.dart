import 'package:foresh_flutter/domain/supabase/entity/normal_mission_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'normal_mission_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class NormalMissionResponse extends NormalMissionEntity {
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

  NormalMissionResponse({
    required this.id_,
    required this.bigTitle_,
    required this.bigSubtitle_,
    required this.rewardCount_,
    required this.remainCount_,
    required this.rewardImage_,
    required this.detailTitle_,
    required this.detailSubtitle_,
    required this.detailContent_,
    required this.isGlobal_,
  }) : super(
          id: id_.toInt(),
          bigTitle: bigTitle_,
          bigSubtitle: bigSubtitle_,
          detailTitle: detailTitle_,
          detailSubtitle: detailSubtitle_,
          detailContent: detailContent_,
          remainCount: remainCount_.toInt(),
          rewardCount: rewardCount_.toInt(),
          rewardImage: rewardImage_,
          isGlobal: isGlobal_,
        );

  factory NormalMissionResponse.fromJson(Map<String, dynamic> json) => _$NormalMissionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$NormalMissionResponseToJson(this);
}
