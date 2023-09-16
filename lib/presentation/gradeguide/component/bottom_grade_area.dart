import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:foresh_flutter/core/gen/colors.gen.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';

class BottomGradeArea extends StatelessWidget {
  final String target;
  final String remainCount;

  const BottomGradeArea({
    super.key,
    required this.target,
    required this.remainCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(text: "${target.tr()}까지", style: FortuneTextStyle.body3Light(fontColor: ColorName.grey200)),
              const TextSpan(text: "\u00A0"),
              TextSpan(text: "$remainCount점", style: FortuneTextStyle.body3Semibold()),
              const TextSpan(text: "\u00A0"),
              TextSpan(text: "남았어요", style: FortuneTextStyle.body3Light(fontColor: ColorName.grey200)),
            ],
          ),
        ),
      ],
    );
  }
}
