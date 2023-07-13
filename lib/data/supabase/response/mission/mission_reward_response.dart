import 'package:foresh_flutter/domain/supabase/entity/mission/mission_reward_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'mission_reward_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class MissionRewardResponse extends MissionRewardEntity {
  @JsonKey(name: 'id')
  final double id_;
  @JsonKey(name: 'total_count')
  final int totalCount_;
  @JsonKey(name: 'reward_name')
  final String rewardName_;
  @JsonKey(name: 'remain_count')
  final int remainCount_;
  @JsonKey(name: 'reward_image')
  final String rewardImage_;
  @JsonKey(name: 'created_at')
  final String createdAt_;

  MissionRewardResponse({
    required this.id_,
    required this.totalCount_,
    required this.rewardName_,
    required this.remainCount_,
    required this.rewardImage_,
    required this.createdAt_,
  }) : super(
          id: id_.toInt(),
          totalCount: totalCount_,
          remainCount: remainCount_,
          rewardName: rewardName_,
          rewardImage: rewardImage_,
          createdAt: createdAt_,
        );

  factory MissionRewardResponse.fromJson(Map<String, dynamic> json) => _$MissionRewardResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MissionRewardResponseToJson(this);
}
