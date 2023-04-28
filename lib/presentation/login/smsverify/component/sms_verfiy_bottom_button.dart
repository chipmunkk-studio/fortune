import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:foresh_flutter/core/widgets/button/fortune_bottom_button.dart';
import 'package:foresh_flutter/presentation/login/smsverify/bloc/sms_verify.dart';

class SmsVerifyBottomButton extends StatelessWidget {
  final bool isKeyboardVisible;
  final Function0 onPress;
  final SmsVerifyState state;

  const SmsVerifyBottomButton(
    this.state, {
    required this.onPress,
    required this.isKeyboardVisible,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FortuneBottomButton(
      isEnabled: state.isEnabled,
      onPress: onPress,
      isKeyboardVisible: isKeyboardVisible,
    );
  }
}
