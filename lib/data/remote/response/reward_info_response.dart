import 'package:fortune/data/remote/response/fortune_image_response.dart';
import 'package:fortune/domain/entity/fortune_image_entity.dart';
import 'package:fortune/domain/entity/reward_info_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reward_info_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class RewardInfoResponse extends RewardInfoEntity {
  @JsonKey(name: 'total_amount')
  final int? totalAmount_;
  @JsonKey(name: 'reward_amount')
  final int? rewardAmount_;
  @JsonKey(name: 'image')
  final FortuneImageResponse? image_;
  @JsonKey(name: 'title')
  final String? title_;
  @JsonKey(name: 'description')
  final String? description_;

  RewardInfoResponse({
    this.totalAmount_,
    this.rewardAmount_,
    this.image_,
    this.title_,
    this.description_,
  }) : super(
          totalAmount: totalAmount_ ?? 0,
          rewardAmount: rewardAmount_ ?? 0,
          image: image_ ?? FortuneImageEntity.empty(),
          title: title_ ?? '',
          description: description_ ?? '',
        );

  factory RewardInfoResponse.fromJson(Map<String, dynamic> json) => _$RewardInfoResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RewardInfoResponseToJson(this);
}
