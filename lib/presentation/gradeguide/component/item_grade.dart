import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fortune/core/gen/colors.gen.dart';
import 'package:fortune/core/util/textstyle.dart';
import 'package:fortune/domain/supabase/entity/fortune_user_grade_entity.dart';

class ItemGrade extends StatelessWidget {
  final FortuneUserGradeEntity gradeInfo;

  const ItemGrade(
    this.gradeInfo, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: ColorName.grey800,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 21),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(gradeInfo.name, style: FortuneTextStyle.body1Semibold()),
              SizedBox(height: 6.h),
              Text("보상 준비 중", style: FortuneTextStyle.body3Light(fontColor: ColorName.grey200)),
            ],
          ),
          const Spacer(),
          gradeInfo.icon.svg(width: 60, height: 60),
        ],
      ),
    );
  }
}
