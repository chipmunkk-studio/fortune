import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';

import 'fortune_bottom_button.dart';

class FortuneTextButton extends StatelessWidget {
  final Function0? onPress;
  final String text;
  final _deBouncer = FortuneButtonDeBouncer(milliseconds: 3000);

  FortuneTextButton({
    Key? key,
    required this.onPress,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => _deBouncer.run(onPress),
      child: Text(
        text,
        style: FortuneTextStyle.body1Medium(),
      ),
    );
  }
}
