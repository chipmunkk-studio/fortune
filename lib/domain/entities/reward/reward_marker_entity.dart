
import 'package:foresh_flutter/domain/entities/marker_grade_entity.dart';

class RewardMarkerEntity {
  final MarkerGradeEntity grade;
  final String count;
  final bool open;

  RewardMarkerEntity({
    required this.grade,
    required this.count,
    required this.open,
  });
}