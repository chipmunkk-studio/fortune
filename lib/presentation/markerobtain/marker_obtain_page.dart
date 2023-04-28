import 'package:flutter/material.dart';
import 'package:foresh_flutter/presentation/markerobtain/component/fortune_cookie.dart';

class MarkerObtainArgs {
  final int grade;
  final String message;

  MarkerObtainArgs({
    required this.grade,
    required this.message,
  });
}

class MarkerObtainPage extends StatelessWidget {
  final int grade;
  final String message;

  const MarkerObtainPage({
    required this.grade,
    required this.message,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (grade == 1) {
      // 포츈쿠키일경우.
      return FortuneCookie(
        grade,
        message,
      );
    } else {
      return Container();
    }
  }
}
