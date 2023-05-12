import 'package:foresh_flutter/data/responses/reward/reward_exchangeable_marker_response.dart';
import 'package:foresh_flutter/data/responses/reward/reward_notice_response.dart';
import 'package:foresh_flutter/domain/entities/marker_grade_entity.dart';
import 'package:foresh_flutter/domain/entities/reward/reward_exchangeable_marker_entity.dart';
import 'package:foresh_flutter/domain/entities/reward/reward_notice_entity.dart';
import 'package:foresh_flutter/domain/entities/reward/reward_product_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reward_product_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class RewardProductResponse extends RewardProductEntity {
  @JsonKey(name: 'rewardId')
  final int? rewardId_;
  @JsonKey(name: 'name')
  final String? name_;
  @JsonKey(name: 'imageUrl')
  final String? imageUrl_;
  @JsonKey(name: 'stock')
  final int? stock_;
  @JsonKey(name: 'exchangeableMarkers')
  final List<RewardExchangeableMarkerResponse>? exchangeableMarkers_;
  @JsonKey(name: 'notices')
  final List<RewardNoticeResponse>? notices_;

  RewardProductResponse({
    required this.rewardId_,
    required this.name_,
    required this.imageUrl_,
    required this.stock_,
    required this.exchangeableMarkers_,
    required this.notices_,
  }) : super(
            rewardId: rewardId_ ?? 0,
            name: name_ ?? "",
            imageUrl: imageUrl_ ?? "",
            stock: stock_ ?? 0,
            exchangeableMarkers: exchangeableMarkers_
                    ?.map(
                      (e) => RewardExchangeableMarkerEntity(
                        grade: getMarkerGradeIconInfo(e.grade ?? 0),
                        count: e.count ?? 0,
                        userHaveCount: e.userHaveCount ?? 0,
                      ),
                    )
                    .toList() ??
                List.empty(),
            notices: notices_
                    ?.map(
                      (e) => RewardNoticeEntity(
                        id: e.id,
                        title: e.title,
                        content: e.content,
                      ),
                    )
                    .toList() ??
                List.empty());

  factory RewardProductResponse.fromJson(Map<String, dynamic> json) => _$RewardProductResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RewardProductResponseToJson(this);
}
