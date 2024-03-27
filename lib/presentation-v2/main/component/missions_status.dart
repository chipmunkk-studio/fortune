import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fortune/core/gen/assets.gen.dart';
import 'package:fortune/core/gen/colors.gen.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/core/util/textstyle.dart';

class MissionsStatus extends StatelessWidget {
  final Function0 onPress;

  const MissionsStatus({
    super.key,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      onTap: onPress,
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              color: ColorName.grey700,
            ),
            child: Assets.icons.icInventory.svg(width: 32, height: 32),
          ),
          const SizedBox(height: 6),
          Text(
            FortuneTr.msgMyMissionStatus,
            style: FortuneTextStyle.body3Semibold(),
          ),
        ],
      ),
    );
  }
}
