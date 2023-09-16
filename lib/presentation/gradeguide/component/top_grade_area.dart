import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';
import 'package:foresh_flutter/domain/supabase/entity/fortune_user_grade_entity.dart';

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
        getUserGradeIconInfo(1).icon.svg(width: 72, height: 72),
      ],
    );
  }
}

class _MyGradeInfo extends StatelessWidget {
  const _MyGradeInfo({
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
                    style: FortuneTextStyle.subTitle1Medium(),
                  ),
                  const SizedBox(height: 4),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: grade.tr(),
                          style: FortuneTextStyle.subTitle1Bold(),
                        ),
                        TextSpan(text: "\u00A0입니다", style: FortuneTextStyle.subTitle1Medium()),
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
