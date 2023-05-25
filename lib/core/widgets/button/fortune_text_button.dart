import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';

class FortuneTextButton extends StatelessWidget {
  final Function0? onPress;
  final String text;
  final _debouncer = _ButtonDebouncer(milliseconds: 1000);

  FortuneTextButton({
    Key? key,
    required this.onPress,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPress != null ? () => _debouncer.run(onPress) : null,
      child: Text(
        text,
        style: FortuneTextStyle.body1Medium(),
      ),
    );
  }
}

class _ButtonDebouncer {
  final int milliseconds;
  bool isFirstClick = true;
  Timer? _timer;

  _ButtonDebouncer({required this.milliseconds});

  run(Function0? action) {
    if (isFirstClick) {
      action?.call();
      isFirstClick = false;
    }

    if (null != _timer) {
      _timer!.cancel();
    }

    _timer = Timer(Duration(milliseconds: milliseconds), () {
      isFirstClick = true;
    });
  }
}
