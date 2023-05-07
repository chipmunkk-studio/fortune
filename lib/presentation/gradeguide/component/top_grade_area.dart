import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';
import 'package:foresh_flutter/domain/entities/user_grade_entity.dart';

class TopGradeArea extends StatelessWidget {
  final String grade;

  const TopGradeArea({
    super.key,
    required this.grade,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _MyGradeInfo(grade: grade),
        getUserGradeIconInfo(1).getIcon(size: 72.w),
      ],
    );
  }
}

class _MyGradeInfo extends StatelessWidget {
  const _MyGradeInfo({
    super.key,
    required this.grade,
  });

  final String grade;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Row(
        children: [
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "나의 현재 등급은",
                    style: FortuneTextStyle.subTitle1Regular(),
                  ),
                  SizedBox(height: 4.h),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: grade.tr(),
                          style: FortuneTextStyle.subTitle1SemiBold(),
                        ),
                        TextSpan(text: "\u00A0입니다", style: FortuneTextStyle.subTitle1Regular()),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
