import 'package:foresh_flutter/domain/supabase/entity/mission_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'mission_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class MissionResponse extends MissionEntity {
  @JsonKey(name: 'id')
  final double id_;
  @JsonKey(name: 'title')
  final String title_;
  @JsonKey(name: 'subtitle')
  final String subtitle_;
  @JsonKey(name: 'reward_count')
  final double rewardCount_;
  @JsonKey(name: 'remain_count')
  final double remainCount_;
  @JsonKey(name: 'reward_image')
  final String rewardImage_;
  @JsonKey(name: 'is_global')
  final bool isGlobal_;

  MissionResponse({
    required this.id_,
    required this.title_,
    required this.subtitle_,
    required this.rewardCount_,
    required this.remainCount_,
    required this.rewardImage_,
    required this.isGlobal_,
  }) : super(
          id: id_.toInt(),
          title: title_,
          subtitle: subtitle_,
          remainCount: remainCount_.toInt(),
          rewardCount: rewardCount_.toInt(),
          rewardImage: rewardImage_,
          isGlobal: isGlobal_,
        );

  factory MissionResponse.fromJson(Map<String, dynamic> json) => _$MissionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MissionResponseToJson(this);
}
