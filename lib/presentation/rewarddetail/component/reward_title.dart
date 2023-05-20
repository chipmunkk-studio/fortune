import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';

class RewardTitle extends StatelessWidget {
  const RewardTitle({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Text(
            title,
            style: FortuneTextStyle.headLine3(),
          ),
        ),
        const SizedBox(width: 84),
      ],
    );
  }
}
