import 'package:foresh_flutter/domain/entities/marker/marker_grade_entity.dart';

class RewardExchangeableMarkerEntity {
  final MarkerGradeEntity grade;
  final int count;
  final int userHaveCount;

  RewardExchangeableMarkerEntity({
    required this.grade,
    required this.count,
    required this.userHaveCount,
  });
}
