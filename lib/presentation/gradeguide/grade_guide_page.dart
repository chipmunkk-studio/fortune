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
        ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            TopGradeArea(
              grade: "브론즈",
            ),
            SizedBox(height: 24.h),
            MiddlePercentage(
              percent: 0.9,
            ),
            SizedBox(height: 12.h),
            BottomGradeArea(
              target: '골드',
              remainCount: '3',
            ),
            SizedBox(height: 40.h),
            ItemGrade(getGradeIconInfo(1)),
            SizedBox(height: 12.h),
            ItemGrade(getGradeIconInfo(2)),
            SizedBox(height: 12.h),
            ItemGrade(getGradeIconInfo(3)),
            SizedBox(height: 12.h),
            ItemGrade(getGradeIconInfo(4)),
            SizedBox(height: 12.h),
            ItemGrade(getGradeIconInfo(5)),
            SizedBox(height: 12.h),
            Text("매월 1일, 누적 점수 기준으로 등급이 부여됩니다.", style: FortuneTextStyle.body3Regular(fontColor: ColorName.activeDark)),
            SizedBox(height: 6.h),
            Text("등급별 혜택 및 선정 기준은 변경될 수 있습니다.", style: FortuneTextStyle.body3Regular(fontColor: ColorName.activeDark)),
          ],
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 50.h,
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
