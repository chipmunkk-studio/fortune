import 'package:flutter/material.dart';
import 'package:fortune/core/gen/assets.gen.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/core/util/textstyle.dart';
import 'package:fortune/core/widgets/fortune_scaffold.dart';

class WebMainPage extends StatelessWidget {
  const WebMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FortuneScaffold(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Assets.images.webMain.image(),
            ),
            const SizedBox(height: 100),
            Text(
              FortuneTr.msgWelcome,
              textAlign: TextAlign.center,
              style: FortuneTextStyle.headLine1(height: 1.3),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
