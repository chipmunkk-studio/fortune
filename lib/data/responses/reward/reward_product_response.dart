import 'package:foresh_flutter/data/responses/reward/reward_exchangeable_marker_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reward_product_response.g.dart';

@JsonSerializable(ignoreUnannotated: false)
class RewardProductResponse {
  @JsonKey(name: 'rewardId')
  final int? rewardId;
  @JsonKey(name: 'name')
  final String? name;
  @JsonKey(name: 'imageUrl')
  final String? imageUrl;
  @JsonKey(name: 'stock')
  final int? stock;
  @JsonKey(name: 'exchangeableMarkers')
  final List<RewardExchangeableMarkerResponse>? exchangeableMarkers;

  RewardProductResponse({
    required this.rewardId,
    required this.name,
    required this.imageUrl,
    required this.stock,
    required this.exchangeableMarkers,
  });

  factory RewardProductResponse.fromJson(Map<String, dynamic> json) => _$RewardProductResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RewardProductResponseToJson(this);
}
