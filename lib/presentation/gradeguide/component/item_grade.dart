import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fortune/core/gen/colors.gen.dart';
import 'package:fortune/core/util/textstyle.dart';
import 'package:fortune/domain/supabase/entity/fortune_user_grade_entity.dart';

class ItemGrade extends StatelessWidget {
  final FortuneUserGradeEntity gradeInfo;
  final String rewardGuideText;

  const ItemGrade(
    this.gradeInfo, {
    super.key,
    required this.rewardGuideText,
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
              Row(
                children: [
                  Text(gradeInfo.name, style: FortuneTextStyle.body1Semibold()),
                  const SizedBox(width: 12),
                  Text(
                    gradeInfo.levelScope,
                    style: FortuneTextStyle.caption1SemiBold(
                      color: ColorName.grey500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(rewardGuideText, style: FortuneTextStyle.body3Light(color: ColorName.grey200)),
            ],
          ),
          const Spacer(),
          gradeInfo.icon.svg(width: 60, height: 60),
        ],
      ),
    );
  }
}
