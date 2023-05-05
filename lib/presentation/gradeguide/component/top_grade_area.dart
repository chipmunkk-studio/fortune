import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foresh_flutter/core/gen/colors.gen.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';
import 'package:foresh_flutter/presentation/fortune_ext.dart';

class TopGradeArea extends StatelessWidget {
  final String nickname;
  final String grade;

  const TopGradeArea({
    super.key,
    required this.nickname,
    required this.grade,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$nickname님의",
                  style: FortuneTextStyle.subTitle1SemiBold(),
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(text: "현재 등급은", style: FortuneTextStyle.subTitle1Regular()),
                      TextSpan(text: "\u00A0", style: FortuneTextStyle.body3Bold(fontColor: ColorName.secondary)),
                      TextSpan(
                        text: grade.tr(),
                        style: FortuneTextStyle.subTitle1SemiBold(fontColor: ColorName.secondary),
                      ),
                      TextSpan(text: "입니다", style: FortuneTextStyle.subTitle1Regular()),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 51.w),
        getGradeIconInfo(1, size: 72.w).icon,
      ],
    );
  }
}
