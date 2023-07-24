import 'package:dartz/dartz.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:foresh_flutter/core/widgets/button/fortune_bottom_button.dart';

class LoginBottomButton extends StatelessWidget {
  final bool isKeyboardVisible;
  final String text;
  final Function0 onPressed;
  final bool isEnabled;

  const LoginBottomButton({
    super.key,
    required this.isKeyboardVisible,
    required this.isEnabled,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return FortuneBottomButton(
      isKeyboardVisible: isKeyboardVisible,
      isEnabled: isEnabled,
      onPress: onPressed,
      buttonText: text,
    );
  }
}
