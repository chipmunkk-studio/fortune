import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foresh_flutter/core/gen/colors.gen.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';

class TopHaveCount extends StatelessWidget {
  final String fortuneCount;

  const TopHaveCount({
    super.key,
    required this.fortuneCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: ColorName.backgroundLight,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("보유한 포춘", style: FortuneTextStyle.body1Regular(fontColor: ColorName.activeDark)),
          const SizedBox(height: 8),
          Text(fortuneCount, style: FortuneTextStyle.subTitle3Bold())
        ],
      ),
    );
  }
}
