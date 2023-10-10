import 'package:flutter/material.dart';
import 'package:fortune/core/util/textstyle.dart';
import 'package:fortune/core/widgets/fortune_scaffold.dart';

class WebMainPage extends StatelessWidget {
  const WebMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FortuneScaffold(
      child: Center(
        child: Text(
          '포춘에 오신것을 환영합니다!',
          style: FortuneTextStyle.headLine1(),
        ),
      ),
    );
  }
}
