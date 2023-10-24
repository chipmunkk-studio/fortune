import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fortune/core/gen/colors.gen.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/core/util/textstyle.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class MiddlePercentage extends StatelessWidget {
  final double percent;
  final int level;

  const MiddlePercentage({
    super.key,
    required this.percent,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    return LinearPercentIndicator(
      animation: true,
      lineHeight: 16,
      animationDuration: 2000,
      percent: percent,
      padding: const EdgeInsets.all(0),
      barRadius: Radius.circular(16.r),
      backgroundColor: ColorName.grey700,
      linearGradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.topRight,
        colors: [
          ColorName.primary,
          ColorName.secondary,
        ],
      ),
      center: Text(
        FortuneTr.msgCenterLevel(level.toString()),
        style: FortuneTextStyle.caption3Semibold(),
      ),
    );
  }
}
