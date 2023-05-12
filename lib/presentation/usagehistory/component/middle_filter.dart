import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foresh_flutter/core/gen/colors.gen.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';

class MiddleFilter extends StatelessWidget {
  final Function1<String, void> onFilterTap;

  const MiddleFilter({
    super.key,
    required this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0, // gap between adjacent chips
      runSpacing: 4.0, // gap between lines
      children: <Widget>[
        Chip(
          labelPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 7.h),
          backgroundColor: Colors.white,
          label: Text('전체', style: FortuneTextStyle.body2SemiBold(fontColor: Colors.black)),
        ),
        Bounceable(
          onTap: () => onFilterTap("OBTAIN"),
          child: Chip(
            label: Text('획득', style: FortuneTextStyle.body2SemiBold(fontColor: ColorName.activeDark)),
            labelPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 7.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100.r),
              side: const BorderSide(
                color: ColorName.deActiveDark,
                width: 1.0,
              ),
            ),
            backgroundColor: ColorName.background,
            elevation: 0,
            shadowColor: Colors.transparent,
          ),
        ),
        Bounceable(
          onTap: () => onFilterTap("USE"),
          child: Chip(
            label: Text('사용', style: FortuneTextStyle.body2SemiBold(fontColor: ColorName.activeDark)),
            labelPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 7.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100.r),
              side: const BorderSide(
                color: ColorName.deActiveDark,
                width: 1.0,
              ),
            ),
            backgroundColor: ColorName.background,
            elevation: 0,
            shadowColor: Colors.transparent,
          ),
        ),
      ],
    );
  }
}
