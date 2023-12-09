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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 20, right: 20, top: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: ColorName.grey800,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(FortuneTr.msgCompletedMissions, style: FortuneTextStyle.body2Regular(color: ColorName.grey200)),
            const SizedBox(height: 8),
            Text('$count건', style: FortuneTextStyle.subTitle2SemiBold(color: ColorName.white)),
          ],
        ),
      ),
    );
  }
}
