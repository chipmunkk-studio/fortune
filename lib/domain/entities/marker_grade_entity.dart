import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foresh_flutter/core/gen/assets.gen.dart';

abstract class MarkerGradeEntity {
  final int grade;
  final SvgGenImage icon;
  final String name;

  MarkerGradeEntity(
    this.grade,
    this.icon,
    this.name,
  );

  SvgPicture getIcon({double size});
}

class MarkerGrade1 implements MarkerGradeEntity {
  @override
  final int grade;

  @override
  final SvgGenImage icon;

  @override
  final String name;

  MarkerGrade1()
      : grade = 1,
        name = "포츈쿠키".tr(),
        icon = Assets.icons.icFortuneCookie;

  @override
  SvgPicture getIcon({double size = 68}) => icon.svg(width: size, height: size);
}

class MakrerGrade2 implements MarkerGradeEntity {
  @override
  final int grade;

  @override
  final SvgGenImage icon;

  @override
  final String name;

  MakrerGrade2()
      : grade = 2,
        name = "silver".tr(),
        icon = Assets.icons.icGradeSilver;

  @override
  SvgPicture getIcon({double size = 68}) => icon.svg(width: size, height: size);
}

class MarkerGrade3 implements MarkerGradeEntity {
  @override
  final int grade;

  @override
  final SvgGenImage icon;

  @override
  final String name;

  MarkerGrade3()
      : grade = 3,
        name = "gold".tr(),
        icon = Assets.icons.icGradeGold;

  @override
  SvgPicture getIcon({double size = 68}) => icon.svg(width: size, height: size);
}

class MarkerGrade4 implements MarkerGradeEntity {
  @override
  final int grade;

  @override
  final SvgGenImage icon;

  @override
  final String name;

  MarkerGrade4()
      : grade = 4,
        name = "platinum".tr(),
        icon = Assets.icons.icGradePlatinum;

  @override
  SvgPicture getIcon({double size = 68}) => icon.svg(width: size, height: size);
}

class MarkerGrade5 implements MarkerGradeEntity {
  @override
  final int grade;

  @override
  final SvgGenImage icon;

  @override
  final String name;

  MarkerGrade5()
      : grade = 5,
        name = "diamond".tr(),
        icon = Assets.icons.icGradeDiamond;

  @override
  SvgPicture getIcon({double size = 68}) => icon.svg(width: size, height: size);
}

class MarkerGrade6 implements MarkerGradeEntity {
  @override
  final int grade;

  @override
  final SvgGenImage icon;

  @override
  final String name;

  MarkerGrade6()
      : grade = 6,
        name = "diamond".tr(),
        icon = Assets.icons.icGradeDiamond;

  @override
  SvgPicture getIcon({double size = 68}) => icon.svg(width: size, height: size);
}

class MarkerGrade7 implements MarkerGradeEntity {
  @override
  final int grade;

  @override
  final SvgGenImage icon;

  @override
  final String name;

  MarkerGrade7()
      : grade = 7,
        name = "diamond".tr(),
        icon = Assets.icons.icGradeDiamond;

  @override
  SvgPicture getIcon({double size = 68}) => icon.svg(width: size, height: size);
}

MarkerGradeEntity getMarkerGradeIconInfo(int grade) {
  switch (grade) {
    case 1:
      return MarkerGrade1();
    case 2:
      return MakrerGrade2();
    case 3:
      return MarkerGrade3();
    case 4:
      return MarkerGrade4();
    case 5:
      return MarkerGrade5();
    case 6:
      return MarkerGrade6();
    case 7:
      return MarkerGrade7();
    default:
      return MarkerGrade1();
  }
}
