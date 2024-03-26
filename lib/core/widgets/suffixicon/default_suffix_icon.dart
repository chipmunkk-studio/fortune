import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DefaultSuffixIcon extends StatelessWidget {
  final String? svgIcon;
  final Function0? press;

  const DefaultSuffixIcon({
    super.key,
    this.svgIcon,
    this.press,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: IconButton(
        icon: SvgPicture.asset(
          svgIcon ?? "",
        ),
        onPressed: press,
        style: IconButton.styleFrom(
            splashFactory: NoSplash.splashFactory
        ),
      ),
    );
  }
}
