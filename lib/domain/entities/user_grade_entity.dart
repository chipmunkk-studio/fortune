import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foresh_flutter/core/gen/assets.gen.dart';

abstract class UserGradeEntity {
  final int grade;
  final String iconPath;
  final String name;

  UserGradeEntity(
    this.grade,
    this.iconPath,
    this.name,
  );

  SvgPicture getIcon({double size = 60});
}

class GradeBronze implements UserGradeEntity {
  @override
  final int grade;

  @override
  final String iconPath;

  @override
  final String name;

  GradeBronze()
      : grade = 1,
        name = "bronze".tr(),
        iconPath = Assets.icons.icGradeBronze.path;

  @override
  SvgPicture getIcon({double size = 60}) => SvgPicture.asset(iconPath);
}

class GradeSilver implements UserGradeEntity {
  @override
  final int grade;

  @override
  final String iconPath;

  @override
  final String name;

  GradeSilver()
      : grade = 2,
        name = "silver".tr(),
        iconPath = Assets.icons.icGradeSilver.path;

  @override
  SvgPicture getIcon({double size = 60}) => SvgPicture.asset(iconPath);
}

class GradeGold implements UserGradeEntity {
  @override
  final int grade;

  @override
  final String iconPath;

  @override
  final String name;

  GradeGold()
      : grade = 3,
        name = "gold".tr(),
        iconPath = Assets.icons.icGradeGold.path;

  @override
  SvgPicture getIcon({double size = 60}) => SvgPicture.asset(iconPath);
}

class GradePlatinum implements UserGradeEntity {
  @override
  final int grade;

  @override
  final String iconPath;

  @override
  final String name;

  GradePlatinum()
      : grade = 4,
        name = "platinum".tr(),
        iconPath = Assets.icons.icGradePlatinum.path;

  @override
  SvgPicture getIcon({double size = 60}) => SvgPicture.asset(iconPath);
}

class GradeDiamond implements UserGradeEntity {
  @override
  final int grade;

  @override
  final String iconPath;

  @override
  final String name;

  GradeDiamond()
      : grade = 5,
        name = "diamond".tr(),
        iconPath = Assets.icons.icGradeDiamond.path;

  @override
  SvgPicture getIcon({double size = 60}) => SvgPicture.asset(iconPath);
}

UserGradeEntity getGradeIconInfo(int grade) {
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
