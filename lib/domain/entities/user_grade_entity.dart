import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foresh_flutter/core/gen/assets.gen.dart';

abstract class UserGradeEntity {
  final int grade;
  final SvgGenImage icon;
  final String name;

  UserGradeEntity(
    this.grade,
    this.icon,
    this.name,
  );
}

class GradeBronze implements UserGradeEntity {
  @override
  final int grade;

  @override
  final SvgGenImage icon;

  @override
  final String name;

  GradeBronze()
      : grade = 1,
        name = "bronze".tr(),
        icon = Assets.icons.icGradeBronze;
}

class GradeSilver implements UserGradeEntity {
  @override
  final int grade;

  @override
  final SvgGenImage icon;

  @override
  final String name;

  GradeSilver()
      : grade = 2,
        name = "silver".tr(),
        icon = Assets.icons.icGradeSilver;
}

class GradeGold implements UserGradeEntity {
  @override
  final int grade;

  @override
  final SvgGenImage icon;

  @override
  final String name;

  GradeGold()
      : grade = 3,
        name = "gold".tr(),
        icon = Assets.icons.icGradeGold;
}

class GradePlatinum implements UserGradeEntity {
  @override
  final int grade;

  @override
  final SvgGenImage icon;

  @override
  final String name;

  GradePlatinum()
      : grade = 4,
        name = "platinum".tr(),
        icon = Assets.icons.icGradePlatinum;
}

class GradeDiamond implements UserGradeEntity {
  @override
  final int grade;

  @override
  final SvgGenImage icon;

  @override
  final String name;

  GradeDiamond()
      : grade = 5,
        name = "diamond".tr(),
        icon = Assets.icons.icGradeDiamond;
}

UserGradeEntity getUserGradeIconInfo(int grade) {
  switch (grade) {
    case 1:
      return GradeBronze();
    case 2:
      return GradeSilver();
    case 3:
      return GradeGold();
    case 4:
      return GradePlatinum();
    case 5:
      return GradeDiamond();
    default:
      return GradeBronze();
  }
}

String getSampleNetworkImageUrl({
  required int width,
  required int height,
}) =>
    "https://source.unsplash.com/user/max_duz/${width}x$height";
