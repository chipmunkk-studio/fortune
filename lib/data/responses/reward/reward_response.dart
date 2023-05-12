import 'package:foresh_flutter/data/responses/reward/reward_marker_response.dart';
import 'package:foresh_flutter/data/responses/reward/reward_product_response.dart';
import 'package:foresh_flutter/domain/entities/reward/reward_entity.dart';
import 'package:foresh_flutter/domain/entities/reward/reward_marker_entity.dart';
import 'package:foresh_flutter/domain/entities/reward/reward_product_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reward_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class RewardResponse extends RewardEntity {
  @JsonKey(name: 'totalMarkerCount')
  final int? totalMarkerCount_;
  @JsonKey(name: 'markers')
  final List<RewardMarkerResponse>? markers_;
  @JsonKey(name: 'rewards')
  final List<RewardProductResponse>? rewards_;

  RewardResponse({
    this.totalMarkerCount_,
    this.markers_,
    this.rewards_,
  }) : super(
          totalMarkerCount: totalMarkerCount_ ?? 0,
          markers: markers_
                  ?.map(
                    (e) => RewardMarkerEntity(
                      grade: e.grade,
                      count: e.count,
                      open: e.open,
                    ),
                  )
                  .toList() ??
              List.empty(),
          rewards: rewards_
                  ?.map(
                    (e) => RewardProductEntity(
                      rewardId: e.rewardId,
                      name: e.name,
                      imageUrl: e.imageUrl,
                      stock: e.stock,
                      exchangeableMarkers: e.exchangeableMarkers,
                      notices: e.notices,
                    ),
                  )
                  .toList() ??
              List.empty(),
        );

  factory RewardResponse.fromJson(Map<String, dynamic> json) => _$RewardResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RewardResponseToJson(this);
}
