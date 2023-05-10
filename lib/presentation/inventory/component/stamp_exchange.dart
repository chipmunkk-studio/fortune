import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foresh_flutter/core/gen/assets.gen.dart';
import 'package:foresh_flutter/core/gen/colors.gen.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';

/// 스탬프 교환소.
class StampExchange extends StatelessWidget {
  const StampExchange({required this.onStampExchangeClick});

  final Function0 onStampExchangeClick;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 24.w),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "포춘 컬렉션",
                    style: FortuneTextStyle.subTitle2Bold(),
                  ),
                ),
              ),
              SizedBox(width: 9.w),
              Assets.icons.icInfo.svg(width: 20, height: 20),
            ],
          ),
        ),
        Bounceable(
          onTap: onStampExchangeClick,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: ColorName.primary.withOpacity(0.1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Assets.icons.icRecycle.svg(width: 16, height: 16),
                SizedBox(width: 4.w),
                Text(
                  "포춘 교환소",
                  style: FortuneTextStyle.body3Bold(fontColor: ColorName.primary),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 20.w),
      ],
    );
  }
}
