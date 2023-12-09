import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:fortune/core/gen/colors.gen.dart';
import 'package:fortune/core/util/textstyle.dart';
import 'package:fortune/core/widgets/button/fortune_scale_button.dart';
import 'package:fortune/core/widgets/fortune_scaffold.dart';

class CustomerAdView extends StatelessWidget {
  final Function0 onPressed;

  const CustomerAdView({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FortuneScaffold(
      backgroundColor: ColorName.grey900,
      child: Column(
        children: [
          Expanded(
            child: Text(
              '안녕하세요 자이언트 칩멍크입니다!\n여기는 광고 지면입니다!!',
              style: FortuneTextStyle.body1Light(height: 1.3),
              textAlign: TextAlign.center,
            ),
          ),
          FortuneScaleButton(
            text: '확인',
            onPress: onPressed,
          )
        ],
      ),
    );
  }
}
