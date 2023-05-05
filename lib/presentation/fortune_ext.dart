import 'package:flutter_svg/flutter_svg.dart';
import 'package:foresh_flutter/core/gen/assets.gen.dart';
import 'package:foresh_flutter/domain/entities/user_grade_entity.dart';

String getSampleNetworkImageUrl({
  required int width,
  required int height,
}) =>
    "https://source.unsplash.com/user/max_duz/${width}x$height";

GradeInfo getGradeIconInfo(int grade, {required double size}) {
  switch (grade) {
    case 1:
      return Bronze(size);
    default:
      return Bronze(size);
  }
}
