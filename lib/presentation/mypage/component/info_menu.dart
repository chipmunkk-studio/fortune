import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fortune/core/gen/assets.gen.dart';
import 'package:fortune/core/gen/colors.gen.dart';
import 'package:fortune/core/util/textstyle.dart';

class InfoMenu extends StatelessWidget {
  final String title;
  final Function0 onTap;
  final SvgPicture icon;
  final bool hasNew;

  const InfoMenu(
    this.title, {
    required this.onTap,
    required this.icon,
    this.hasNew = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              icon,
              const SizedBox(width: 12),
              Text(title, style: FortuneTextStyle.body1Light()),
              if (hasNew) ...[
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100.r),
                    color: ColorName.negativeDark,
                  ),
                  child: Text(
                    'NEW',
                    style: FortuneTextStyle.caption3Semibold(color: ColorName.negative),
                  ),
                ),
              ],
              Expanded(child: Container(color: Colors.transparent)),
              Assets.icons.icArrowRight16.svg(
                width: 16,
                height: 16,
                color: ColorName.grey400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
