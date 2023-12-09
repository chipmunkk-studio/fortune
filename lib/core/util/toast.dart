import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fortune/core/gen/assets.gen.dart';
import 'package:fortune/core/gen/colors.gen.dart';
import 'package:fortune/core/util/textstyle.dart';

fortuneToastContent({
  required String content,
  SvgPicture? icon,
}) =>
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 13.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.r),
        color: ColorName.white,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon ?? Assets.icons.icCheckCircleFill24.svg(),
          const SizedBox(width: 12.0),
          Text(
            content,
            style: FortuneTextStyle.body3Regular(color: ColorName.grey900),
          ),
          const SizedBox(width: 12.0),
        ],
      ),
    );
