import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';
import 'package:foresh_flutter/presentation/main/main_ext.dart';

class FortuneCookie extends StatefulWidget {
  final String message;
  final int grade;

  const FortuneCookie(
    this.grade,
    this.message, {
    Key? key,
  }) : super(key: key);

  @override
  State<FortuneCookie> createState() => _FortuneCookieState();
}

class _FortuneCookieState extends State<FortuneCookie> {
  int _tapCount = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _tapCount++;
          if (_tapCount == 3) {
            Navigator.of(context).pop();
            showToast(
              widget.message,
              context: context,
              animation: StyledToastAnimation.fadeScale,
              reverseAnimation: StyledToastAnimation.fade,
              position: StyledToastPosition.center,
              animDuration: const Duration(seconds: 1),
              textAlign: TextAlign.center,
              textStyle: FortuneTextStyle.body1Regular(),
              duration: const Duration(seconds: 4),
              curve: Curves.linear,
              reverseCurve: Curves.linear,
            );
          }
        });
      },
      child: Container(
        child: getMarkerIcon(widget.grade),
      ),
    );
  }
}
