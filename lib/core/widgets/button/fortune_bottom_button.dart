import 'dart:async';

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
  final _debouncer = _ButtonDebouncer(milliseconds: 500);

  FortuneBottomButton({
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
      press: () => _debouncer.run(onPress),
    );
  }
}

class _ButtonDebouncer {
  final int milliseconds;
  VoidCallback? action;
  Timer? _timer;

  _ButtonDebouncer({required this.milliseconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
