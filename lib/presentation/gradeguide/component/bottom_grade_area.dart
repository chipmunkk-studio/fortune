import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fortune/core/gen/colors.gen.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/core/util/textstyle.dart';

class BottomGradeArea extends StatelessWidget {
  final String target;
  final String remainCount;

  const BottomGradeArea({
    super.key,
    required this.target,
    required this.remainCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(text: FortuneTr.msgUntilNextLevel, style: FortuneTextStyle.body3Regular(color: ColorName.grey200)),
                const TextSpan(text: "\u00A0"),
                TextSpan(text: "$remainCount${FortuneTr.msgNumberPrefix}", style: FortuneTextStyle.body3Semibold()),
                TextSpan(
                  text: FortuneTr.msgMarkerRequirement,
                  style: FortuneTextStyle.body3Regular(
                    color: ColorName.grey200,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
