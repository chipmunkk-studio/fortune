import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foresh_flutter/core/gen/assets.gen.dart';

abstract class GradeInfo {
  final int grade;
  final SvgPicture icon;
  final String name;

  GradeInfo(
    this.grade,
    this.icon,
    this.name,
  );
}

class Bronze implements GradeInfo {
  @override
  final int grade;

  @override
  final SvgPicture icon;

  @override
  final String name;

  Bronze(double iconSize)
      : grade = 1,
        name = "bronze".tr(),
        icon = Assets.icons.icGradeBronze.svg(width: iconSize, height: iconSize);
}
