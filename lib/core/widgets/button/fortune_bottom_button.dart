import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fortune/core/widgets/button/fortune_scale_button.dart';


class FortuneBottomButton extends StatelessWidget {
  final bool isEnabled;
  final Function0 onPress;
  final String text;
  final bool isKeyboardVisible;
  final _deBouncer = FortuneButtonDeBouncer(milliseconds: 3000);

  FortuneBottomButton({
    Key? key,
    required this.isEnabled,
    required this.onPress,
    required this.text,
    required this.isKeyboardVisible,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FortuneScaleButton(
      text: text,
      isEnabled: isEnabled,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: isKeyboardVisible ? BorderRadius.circular(0.r) : BorderRadius.circular(50.r),
        ),
      ),
      onPress: () => _deBouncer.run(onPress),
    );
  }
}

class FortuneButtonDeBouncer {
  final int milliseconds;
  Timer? _timer;

  FortuneButtonDeBouncer({required this.milliseconds});

  run(VoidCallback? action) {
    if (_timer != null) return;
    action?.call();
    _timer = Timer(Duration(milliseconds: milliseconds), () {
      _timer = null;
    });
  }
}
