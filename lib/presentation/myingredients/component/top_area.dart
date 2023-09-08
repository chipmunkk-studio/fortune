import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foresh_flutter/core/gen/colors.gen.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';

class TopArea extends StatelessWidget {
  const TopArea({
    super.key,
    required this.count,
  });

  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 24),
        Text(
          "내 가방",
          style: FortuneTextStyle.headLine2(),
        ),
        const SizedBox(width: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            color: ColorName.primary.withOpacity(0.1),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          child: Text(
            '$count개',
            style: FortuneTextStyle.caption1SemiBold(fontColor: ColorName.primary),
          ),
        )
      ],
    );
  }
}
