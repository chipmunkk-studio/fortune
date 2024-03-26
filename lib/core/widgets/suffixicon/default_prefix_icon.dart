import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DefaultPrefixIcon extends StatelessWidget {
  final String? svgIcon;
  final Function0? press;

  const DefaultPrefixIcon({
    super.key,
    this.svgIcon,
    this.press,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: SvgPicture.asset(
        svgIcon ?? "",
      ),
      onPressed: press,
    );
  }
}
