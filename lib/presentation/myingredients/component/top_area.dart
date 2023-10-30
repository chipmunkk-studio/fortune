import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fortune/core/gen/colors.gen.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/core/util/textstyle.dart';

class TopArea extends StatelessWidget {
  const TopArea({
    super.key,
    required this.count,
  });

  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(width: 24.h),
        Text(
          FortuneTr.myBag,
          style: FortuneTextStyle.headLine2(isSpMax: false),
        ),
        SizedBox(width: 8.h),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            color: ColorName.primary.withOpacity(0.1),
          ),
          padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 5.h),
          child: Text(
            '$count ${FortuneTr.msgNumberItems}',
            style: FortuneTextStyle.caption1SemiBold(color: ColorName.primary, isSpMax: false),
          ),
        )
      ],
    );
  }
}
