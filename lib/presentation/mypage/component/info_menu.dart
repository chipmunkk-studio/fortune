import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fortune/core/gen/assets.gen.dart';
import 'package:fortune/core/gen/colors.gen.dart';
import 'package:fortune/core/util/textstyle.dart';

class InfoMenu extends StatelessWidget {
  final String title;
  final Function0 onTap;
  final SvgPicture icon;

  const InfoMenu(
    this.title, {
    required this.onTap,
    required this.icon,
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
            children: [
              icon,
              const SizedBox(width: 12),
              Text(title, style: FortuneTextStyle.body1Light()),
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
