import 'package:flutter/material.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/core/util/textstyle.dart';
import 'package:fortune/core/widgets/fortune_scaffold.dart';

class WebMainPage extends StatelessWidget {
  const WebMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FortuneScaffold(
      child: Center(
        child: Text(
          FortuneTr.msgWelcome,
          textAlign: TextAlign.center,
          style: FortuneTextStyle.headLine1(height: 1.3),
        ),
      ),
    );
  }
}
