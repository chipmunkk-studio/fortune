import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foresh_flutter/core/widgets/button/fortune_scale_button.dart';

class FortuneBottomButton extends StatelessWidget {
  final bool isEnabled;
  final Function0 onPress;
  final String buttonText;
  final bool isKeyboardVisible;

  const FortuneBottomButton({
    Key? key,
    required this.isEnabled,
    required this.onPress,
    required this.buttonText,
    required this.isKeyboardVisible,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FortuneScaleButton(
      text: buttonText,
      isEnabled: isEnabled,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: isKeyboardVisible ? BorderRadius.circular(0.r) : BorderRadius.circular(100.r),
        ),
      ),
      press: onPress,
    );
  }
}
