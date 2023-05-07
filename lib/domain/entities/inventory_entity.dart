import 'package:foresh_flutter/domain/entities/marker_grade_entity.dart';
import 'package:foresh_flutter/domain/entities/user_grade_entity.dart';

class InventoryEntity {
  final String nickname;
  final String profileImage;
  final List<InventoryMarkerEntity> markers;

  InventoryEntity({
    required this.nickname,
    required this.profileImage,
    required this.markers,
  });
}

class InventoryMarkerEntity {
  final MarkerGradeEntity grade;
  final int count;
  final bool open;

  InventoryMarkerEntity({
    required this.grade,
    required this.count,
    required this.open,
  });
}
