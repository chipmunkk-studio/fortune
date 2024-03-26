
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:fortune/core/util/textstyle.dart';

import 'fortune_bottom_button.dart';

class FortuneTextButton extends StatelessWidget {
  final Function0? onPress;
  final String text;
  final _deBouncer = FortuneButtonDeBouncer(milliseconds: 3000);
  final TextStyle? textStyle;

  FortuneTextButton({
    super.key,
    required this.onPress,
    required this.text,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPress != null ? () => _deBouncer.run(onPress) : null,
      child: Text(
        text,
        style: textStyle ?? FortuneTextStyle.caption1SemiBold(),
      ),
    );
  }
}
