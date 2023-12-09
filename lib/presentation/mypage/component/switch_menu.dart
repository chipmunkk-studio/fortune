import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fortune/core/util/snackbar.dart';
import 'package:fortune/core/util/textstyle.dart';
import 'package:fortune/core/widgets/button/fortune_switch_button.dart';

class SwitchMenu extends StatelessWidget {
  final String title;
  final Function1<bool, void> onTap;
  final SvgPicture icon;
  final bool isOn;

  const SwitchMenu(
    this.title, {
    required this.onTap,
    required this.icon,
    required this.isOn,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: IntrinsicHeight(
        child: Row(
          children: [
            icon,
            const SizedBox(width: 12),
            Text(title, style: FortuneTextStyle.body1Regular()),
            const Spacer(),
            FortuneSwitchButton(
              isOn: isOn,
              onToggle: onTap,
            )
          ],
        ),
      ),
    );
  }
}
