import 'package:fortune/core/util/locale.dart';
import 'package:fortune/domain/supabase/entity/mission/mission_reward_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'mission_reward_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class MissionRewardResponse extends MissionRewardEntity {
  @JsonKey(name: 'id')
  final double id_;
  @JsonKey(name: 'total_count')
  final int totalCount_;
  @JsonKey(name: 'kr_reward_name')
  final String krRewardName_;
  @JsonKey(name: 'en_reward_name')
  final String enRewardName_;
  @JsonKey(name: 'remain_count')
  final int remainCount_;
  @JsonKey(name: 'reward_image')
  final String rewardImage_;
  @JsonKey(name: 'kr_note')
  final String krNote_;
  @JsonKey(name: 'en_note')
  final String enNote_;
  @JsonKey(name: 'created_at')
  final String createdAt_;

  MissionRewardResponse({
    required this.id_,
    required this.totalCount_,
    required this.krRewardName_,
    required this.enRewardName_,
    required this.remainCount_,
    required this.rewardImage_,
    required this.enNote_,
    required this.krNote_,
    required this.createdAt_,
  }) : super(
          id: id_.toInt(),
          totalCount: totalCount_,
          remainCount: remainCount_,
          rewardName: getLocaleContent(en: enRewardName_ ?? '', kr: krRewardName_ ?? ''),
          rewardImage: rewardImage_,
          note: getLocaleContent(en: enNote_ ?? '', kr: krNote_ ?? ''),
          createdAt: createdAt_,
        );

  factory MissionRewardResponse.fromJson(Map<String, dynamic> json) => _$MissionRewardResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MissionRewardResponseToJson(this);
}
