import 'package:animation_list/animation_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foresh_flutter/core/gen/colors.gen.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';
import 'package:foresh_flutter/core/widgets/fortune_scaffold.dart';
import 'package:foresh_flutter/domain/entities/user_grade_entity.dart';
import 'package:foresh_flutter/presentation/gradeguide/component/bottom_grade_area.dart';
import 'package:foresh_flutter/presentation/gradeguide/component/item_grade.dart';
import 'package:foresh_flutter/presentation/gradeguide/component/middle_percentage.dart';
import 'package:foresh_flutter/presentation/gradeguide/component/top_grade_area.dart';

class GradeGuidePage extends StatelessWidget {
  const GradeGuidePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FortuneScaffold(
      appBar: FortuneCustomAppBar.leadingAppBar(context, title: "등급안내"),
      child: const _GradeGuidePage(),
    );
  }
}

class _GradeGuidePage extends StatefulWidget {
  const _GradeGuidePage({Key? key}) : super(key: key);

  @override
  State<_GradeGuidePage> createState() => _GradeGuidePageState();
}

class _GradeGuidePageState extends State<_GradeGuidePage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimationList(
          physics: const BouncingScrollPhysics(),
          duration: 1500,
          reBounceDepth: 10,
          children: [
            const TopGradeArea(
              grade: "브론즈",
            ),
            const SizedBox(height: 24),
            const MiddlePercentage(
              percent: 0.9,
            ),
            const SizedBox(height: 12),
            const BottomGradeArea(
              target: '골드',
              remainCount: '3',
            ),
            const SizedBox(height: 40),
            ItemGrade(getUserGradeIconInfo(1)),
            const SizedBox(height: 12),
            ItemGrade(getUserGradeIconInfo(2)),
            const SizedBox(height: 12),
            ItemGrade(getUserGradeIconInfo(3)),
            const SizedBox(height: 12),
            ItemGrade(getUserGradeIconInfo(4)),
            const SizedBox(height: 12),
            ItemGrade(getUserGradeIconInfo(5)),
            const SizedBox(height: 12),
            Text("매월 1일, 누적 점수 기준으로 등급이 부여됩니다.", style: FortuneTextStyle.body3Regular(fontColor: ColorName.activeDark)),
            const SizedBox(height: 6),
            Text("등급별 혜택 및 선정 기준은 변경될 수 있습니다.", style: FortuneTextStyle.body3Regular(fontColor: ColorName.activeDark)),
          ],
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  ColorName.background.withOpacity(1.0),
                  ColorName.background.withOpacity(0.0),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
