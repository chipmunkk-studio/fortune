import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foresh_flutter/core/gen/colors.gen.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class MiddlePercentage extends StatelessWidget {
  final double percent;

  const MiddlePercentage({
    super.key,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    return LinearPercentIndicator(
      animation: true,
      lineHeight: 12,
      animationDuration: 2000,
      percent: percent,
      padding: const EdgeInsets.all(0),
      barRadius: Radius.circular(16.r),
      backgroundColor: ColorName.secondary.withOpacity(0.4),
      progressColor: ColorName.secondary,
    );
  }
}
