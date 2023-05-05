import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foresh_flutter/core/gen/assets.gen.dart';
import 'package:foresh_flutter/core/gen/colors.gen.dart';
import 'package:foresh_flutter/core/util/snackbar.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';
import 'package:foresh_flutter/core/widgets/animation/scale_widget.dart';
import 'package:foresh_flutter/core/widgets/button/fortune_switch_button.dart';

class SwitchMenu extends StatelessWidget {
  final String title;
  final Function0 onTap;
  final SvgPicture icon;

  const SwitchMenu(
    this.title, {
    required this.onTap,
    required this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 18.h),
      child: IntrinsicHeight(
        child: Row(
          children: [
            icon,
            SizedBox(width: 12.w),
            Text(title, style: FortuneTextStyle.body1Regular()),
            const Spacer(),
            FortuneSwitchButton(
              onToggle: (isOn) {
                context.showSnackBar("$isOn");
              },
            )
          ],
        ),
      ),
    );
  }
}
