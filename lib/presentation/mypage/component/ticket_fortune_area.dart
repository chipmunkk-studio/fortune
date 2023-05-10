import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foresh_flutter/core/gen/colors.gen.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';
import 'package:foresh_flutter/core/widgets/animation/scale_widget.dart';

class TicketFortuneArea extends StatelessWidget {
  final Function0 onTicketClick;
  final Function0 onMoneyClick;
  final Function0 onFortuneClick;

  const TicketFortuneArea({
    super.key,
    required this.onTicketClick,
    required this.onMoneyClick,
    required this.onFortuneClick,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: ColorName.backgroundLight,
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Bounceable(
                onTap: onTicketClick,
                child: Container(
                  color: Colors.transparent,
                  padding: EdgeInsets.symmetric(vertical: 18.h),
                  child: Column(
                    children: [
                      Text("티켓", style: FortuneTextStyle.body3Regular(fontColor: ColorName.activeDark)),
                      SizedBox(height: 4.h),
                      Text("10", style: FortuneTextStyle.body2SemiBold(fontColor: ColorName.active)),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: const VerticalDivider(width: 1, color: ColorName.deActiveDark),
            ),
            Expanded(
              child: Bounceable(
                onTap: onMoneyClick,
                child: Container(
                  color: Colors.transparent,
                  padding: EdgeInsets.symmetric(vertical: 18.h),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("머니", style: FortuneTextStyle.body3Regular(fontColor: ColorName.activeDark)),
                      SizedBox(height: 4.h),
                      Text("10", style: FortuneTextStyle.body2SemiBold(fontColor: ColorName.active)),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: const VerticalDivider(width: 1, color: ColorName.deActiveDark),
            ),
            Expanded(
              child: Bounceable(
                onTap: onFortuneClick,
                child: Container(
                  color: Colors.transparent,
                  padding: EdgeInsets.symmetric(vertical: 18.h),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("포춘", style: FortuneTextStyle.body3Regular(fontColor: ColorName.activeDark)),
                      SizedBox(height: 4.h),
                      Text("1234", style: FortuneTextStyle.body2SemiBold(fontColor: ColorName.active)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
