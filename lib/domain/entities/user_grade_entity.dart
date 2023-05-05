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

class GradeBronze implements GradeInfo {
  @override
  final int grade;

  @override
  final SvgPicture icon;

  @override
  final String name;

  GradeBronze(double iconSize)
      : grade = 1,
        name = "bronze".tr(),
        icon = Assets.icons.icGradeBronze.svg(width: iconSize, height: iconSize);
}

class GradeSilver implements GradeInfo {
  @override
  final int grade;

  @override
  final SvgPicture icon;

  @override
  final String name;

  GradeSilver(double iconSize)
      : grade = 2,
        name = "silver".tr(),
        icon = Assets.icons.icGradeSilver.svg(width: iconSize, height: iconSize);
}

class GradeGold implements GradeInfo {
  @override
  final int grade;

  @override
  final SvgPicture icon;

  @override
  final String name;

  GradeGold(double iconSize)
      : grade = 3,
        name = "gold".tr(),
        icon = Assets.icons.icGradeGold.svg(width: iconSize, height: iconSize);
}

class GradePlatinum implements GradeInfo {
  @override
  final int grade;

  @override
  final SvgPicture icon;

  @override
  final String name;

  GradePlatinum(double iconSize)
      : grade = 4,
        name = "platinum".tr(),
        icon = Assets.icons.icGradePlatinum.svg(width: iconSize, height: iconSize);
}

class GradeDiamond implements GradeInfo {
  @override
  final int grade;

  @override
  final SvgPicture icon;

  @override
  final String name;

  GradeDiamond(double iconSize)
      : grade = 5,
        name = "diamond".tr(),
        icon = Assets.icons.icGradeDiamond.svg(width: iconSize, height: iconSize);
}
