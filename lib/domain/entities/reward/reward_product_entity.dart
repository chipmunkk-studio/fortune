import 'package:foresh_flutter/domain/entities/reward/reward_notice_entity.dart';

import 'reward_exchangeable_marker_entity.dart';

abstract class RewardProductPagingEntity {}

class RewardProductEntity extends RewardProductPagingEntity {
  final int rewardId;
  final String name;
  final String imageUrl;
  final int stock;
  final List<RewardExchangeableMarkerEntity> exchangeableMarkers;
  final List<RewardNoticeEntity> notices;

  RewardProductEntity({
    required this.rewardId,
    required this.name,
    required this.imageUrl,
    required this.stock,
    required this.exchangeableMarkers,
    required this.notices,
  });
}

class RewardProductLoading extends RewardProductPagingEntity {}
