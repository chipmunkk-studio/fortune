import 'package:dartz/dartz.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:foresh_flutter/core/widgets/button/fortune_bottom_button.dart';

class LoginBottomButton extends StatelessWidget {
  final bool isKeyboardVisible;
  final FluroRouter router;
  final Function0 onPressed;
  final bool isEnabled;

  const LoginBottomButton(
    this.isKeyboardVisible,
    this.router, {
    super.key,
    required this.onPressed,
    this.isEnabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return FortuneBottomButton(
      isKeyboardVisible: isKeyboardVisible,
      isEnabled: isEnabled,
      onPress: onPressed,
      buttonText: '다음',
    );
  }
}
