import 'package:easy_localization/easy_localization.dart';
import 'package:fortune/core/gen/assets.gen.dart';

abstract class FortuneUserGradeEntity {
  final int grade;
  final SvgGenImage icon;
  final String name;

  final String levelScope;

  FortuneUserGradeEntity(
    this.grade,
    this.icon,
    this.name,
    this.levelScope,
  );
}

class GradeBronze implements FortuneUserGradeEntity {
  @override
  final int grade;

  @override
  final SvgGenImage icon;

  @override
  final String name;

  @override
  final String levelScope;

  GradeBronze()
      : grade = 1,
        name = "bronze".tr(),
        icon = Assets.icons.icGradeBronze,
        levelScope = "Lv. 1 ~ 29";
}

class GradeSilver implements FortuneUserGradeEntity {
  @override
  final int grade;

  @override
  final SvgGenImage icon;

  @override
  final String name;

  @override
  final String levelScope;

  GradeSilver()
      : grade = 2,
        name = "silver".tr(),
        icon = Assets.icons.icGradeSilver,
        levelScope = "Lv. 30 ~ 59";
}

class GradeGold implements FortuneUserGradeEntity {
  @override
  final int grade;

  @override
  final SvgGenImage icon;

  @override
  final String name;

  @override
  final String levelScope;

  GradeGold()
      : grade = 3,
        name = "gold".tr(),
        icon = Assets.icons.icGradeGold,
        levelScope = "Lv. 60 ~ 89";
}

class GradePlatinum implements FortuneUserGradeEntity {
  @override
  final int grade;

  @override
  final SvgGenImage icon;

  @override
  final String name;

  @override
  final String levelScope;

  GradePlatinum()
      : grade = 4,
        name = "platinum".tr(),
        icon = Assets.icons.icGradePlatinum,
        levelScope = "Lv. 90 ~ 119";
}

class GradeDiamond implements FortuneUserGradeEntity {
  @override
  final int grade;

  @override
  final SvgGenImage icon;

  @override
  final String name;

  @override
  final String levelScope;

  GradeDiamond()
      : grade = 5,
        name = "diamond".tr(),
        icon = Assets.icons.icGradeDiamond,
        levelScope = "Lv. 120 ~ ";
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
