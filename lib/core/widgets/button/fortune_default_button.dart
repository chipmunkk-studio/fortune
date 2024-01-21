import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fortune/core/util/textstyle.dart';

class FortuneDefaultButton extends StatelessWidget {
  const FortuneDefaultButton({
    super.key,
    required this.text,
    required this.textColor,
    required this.onPress,
    required this.backgroundColor,
  });

  final String text;
  final Function0 onPress;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      onTap: onPress,
      child: Container(
        decoration: ShapeDecoration(
          color: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100.r),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: FortuneTextStyle.button1Medium(color: textColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
