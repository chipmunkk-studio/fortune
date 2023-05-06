import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foresh_flutter/core/gen/colors.gen.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';
import 'package:foresh_flutter/domain/entities/user_grade_entity.dart';

class ItemGrade extends StatelessWidget {
  final UserGradeEntity gradeInfo;

  const ItemGrade(
    this.gradeInfo, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: ColorName.backgroundLight,
      ),
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 21.h),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(gradeInfo.name, style: FortuneTextStyle.body1SemiBold()),
              SizedBox(height: 6.h),
              Text("누적 00점 이상 달성 시 00회 무료", style: FortuneTextStyle.body3Regular(fontColor: ColorName.activeDark)),
            ],
          ),
          Spacer(),
          gradeInfo.getIcon(),
        ],
      ),
    );
  }
}
