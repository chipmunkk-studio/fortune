import 'package:fortune/domain/entity/fortune_image_entity.dart';
import 'package:fortune/domain/entity/mission_entity.dart';
import 'package:json_annotation/json_annotation.dart';

import 'fortune_image_response.dart';
import 'mission_guide_response.dart';
import 'mission_marker_response.dart';
import 'reward_info_response.dart';

part 'mission_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class MissionResponse extends MissionEntity {
  @JsonKey(name: 'id')
  final String? id_;
  @JsonKey(name: 'title')
  final String? title_;
  @JsonKey(name: 'description')
  final String? description_;
  @JsonKey(name: 'image')
  final FortuneImageResponse? image_;
  @JsonKey(name: 'start_at')
  final String? startAt_;
  @JsonKey(name: 'end_at')
  final String? endAt_;
  @JsonKey(name: 'total_reward_count')
  final int? totalRewardCount_;
  @JsonKey(name: 'remain_reward_count')
  final int? remainRewardCount_;
  @JsonKey(name: 'total_item_count')
  final int? totalItemCount_;
  @JsonKey(name: 'obtained_item_count')
  final int? obtainedItemCount_;
  @JsonKey(name: 'items')
  final List<MissionMarkerResponse>? items_;
  @JsonKey(name: 'guide')
  final MissionGuideResponse? guide_;
  @JsonKey(name: 'reward_info')
  final RewardInfoResponse? rewardInfo_;
  @JsonKey(name: 'is_scheduled')
  final bool? isScheduled_;

  MissionResponse({
    this.id_,
    this.title_,
    this.description_,
    this.image_,
    this.startAt_,
    this.endAt_,
    this.totalRewardCount_,
    this.remainRewardCount_,
    this.totalItemCount_,
    this.obtainedItemCount_,
    this.items_,
    this.guide_,
    this.rewardInfo_,
    this.isScheduled_,
  }) : super(
          id: id_ ?? '',
          title: title_ ?? '',
          description: description_ ?? '',
          image: image_ ?? FortuneImageEntity.empty(),
          startAt: startAt_ ?? '',
          endAt: endAt_ ?? '',
          totalRewardCount: totalItemCount_ ?? 0,
          remainRewardCount: remainRewardCount_ ?? 0,
          totalItemCount: totalItemCount_ ?? 0,
          obtainedItemCount: obtainedItemCount_ ?? 0,
          items: items_
                  ?.map(
                    (e) => MissionMarkerResponse(
                      id_: e.id,
                      name_: e.name,
                      imageUrl_: e.imageUrl,
                      requiredCount_: e.requiredCount,
                      obtainedCount_: 0,
                    ),
                  )
                  ?.toList() ??
              List.empty(),
          guide: guide_ ??
              MissionGuideResponse(
                mission_: guide_?.mission_,
                reward_: guide_?.reward_,
                caution_: guide_?.caution_,
              ),
          rewardInfo: rewardInfo_ ??
              RewardInfoResponse(
                totalAmount_: rewardInfo_?.totalAmount_,
                rewardAmount_: rewardInfo_?.rewardAmount_,
                image_: rewardInfo_?.image_,
                title_: rewardInfo_?.title_,
                description_: rewardInfo_?.description_,
              ),
          isScheduled: isScheduled_ ?? false,
        );

  factory MissionResponse.fromJson(Map<String, dynamic> json) => _$MissionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MissionResponseToJson(this);
}
