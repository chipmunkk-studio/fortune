import 'package:easy_localization/easy_localization.dart';
import 'package:fortune/core/gen/assets.gen.dart';

abstract class FortuneUserGradeEntity {
  final int grade;
  final SvgGenImage icon;
  final String name;

  FortuneUserGradeEntity(
    this.grade,
    this.icon,
    this.name,
  );
}

class GradeBronze implements FortuneUserGradeEntity {
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

class GradeSilver implements FortuneUserGradeEntity {
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

class GradeGold implements FortuneUserGradeEntity {
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

class GradePlatinum implements FortuneUserGradeEntity {
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

class GradeDiamond implements FortuneUserGradeEntity {
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

FortuneUserGradeEntity getUserGradeIconInfo(int grade) {
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

FortuneUserGradeEntity getNextGrade(FortuneUserGradeEntity currentGrade) {
  Map<int, FortuneUserGradeEntity> gradeMap = {
    1: GradeSilver(),
    2: GradeGold(),
    3: GradePlatinum(),
    4: GradeDiamond(),
    5: GradeDiamond(),
  };
  return gradeMap[currentGrade.grade]!;
}
