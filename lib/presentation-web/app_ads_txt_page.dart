import 'package:flutter/material.dart';
import 'package:fortune/core/util/textstyle.dart';

class AppAdsTxtPage extends StatelessWidget {
  const AppAdsTxtPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'facebook.com, 204953610895901, DIRECT, c3e20eee3f780d68',
          style: FortuneTextStyle.body1Light(),
        ),
      ],
    );
  }
}
