import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/core/util/textstyle.dart';
import 'package:fortune/domain/supabase/entity/fortune_user_grade_entity.dart';

class TopGradeArea extends StatelessWidget {
  final FortuneUserGradeEntity grade;

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
        _MyGradeInfo(grade: grade.name),
        getUserGradeIconInfo(grade.id).icon.svg(width: 72, height: 72),
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
                    FortuneTr.msgCurrentGradePrefix,
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
                        TextSpan(
                            text: "\u00A0${FortuneTr.msgCurrentGradeSuffix}",
                            style: FortuneTextStyle.subTitle1Medium()),
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
