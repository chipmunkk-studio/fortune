import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foresh_flutter/core/gen/colors.gen.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';

class TicketFortuneArea extends StatelessWidget {
  const TicketFortuneArea({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: ColorName.backgroundLight,
      ),
      child: IntrinsicHeight(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 18.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("티켓", style: FortuneTextStyle.body3Regular(fontColor: ColorName.activeDark)),
                    SizedBox(height: 4.h),
                    Text("10", style: FortuneTextStyle.body2SemiBold(fontColor: ColorName.active)),
                  ],
                ),
              ),
              const VerticalDivider(width: 1, color: ColorName.deActiveDark),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("머니", style: FortuneTextStyle.body3Regular(fontColor: ColorName.activeDark)),
                    SizedBox(height: 4.h),
                    Text("10", style: FortuneTextStyle.body2SemiBold(fontColor: ColorName.active)),
                  ],
                ),
              ),
              const VerticalDivider(width: 1, color: ColorName.deActiveDark),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("포춘", style: FortuneTextStyle.body3Regular(fontColor: ColorName.activeDark)),
                    SizedBox(height: 4.h),
                    Text("1234", style: FortuneTextStyle.body2SemiBold(fontColor: ColorName.active)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
