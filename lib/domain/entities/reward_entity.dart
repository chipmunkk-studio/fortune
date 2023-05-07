import 'package:foresh_flutter/domain/entities/marker_grade_entity.dart';

class RewardEntity {
  final int totalMarkerCount;
  final List<RewardMarkerEntity> markers;
  final List<RewardProductEntity> rewards;

  RewardEntity({
    required this.totalMarkerCount,
    required this.markers,
    required this.rewards,
  });
}

class RewardMarkerEntity {
  final MarkerGradeEntity grade;
  final int count;
  final bool open;

  RewardMarkerEntity({
    required this.grade,
    required this.count,
    required this.open,
  });
}

class RewardProductEntity {
  final int rewardId;
  final String name;
  final String imageUrl;
  final int stock;
  final List<ExchangeableMarkerEntity> exchangeableMarkers;

  RewardProductEntity({
    required this.rewardId,
    required this.name,
    required this.imageUrl,
    required this.stock,
    required this.exchangeableMarkers,
  });
}

class ExchangeableMarkerEntity {
  final MarkerGradeEntity grade;
  final int count;
  final int userHaveCount;

  ExchangeableMarkerEntity({
    required this.grade,
    required this.count,
    required this.userHaveCount,
  });
}
