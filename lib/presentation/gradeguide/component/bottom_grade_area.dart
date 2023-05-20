import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:foresh_flutter/core/gen/assets.gen.dart';
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
              TextSpan(text: "${target.tr()}까지", style: FortuneTextStyle.body3Regular()),
              TextSpan(text: "\u00A0", style: FortuneTextStyle.body3Bold(fontColor: ColorName.secondary)),
              TextSpan(text: "$remainCount점", style: FortuneTextStyle.body3Bold()),
              TextSpan(text: "\u00A0", style: FortuneTextStyle.body3Bold(fontColor: ColorName.secondary)),
              TextSpan(text: "남았어요", style: FortuneTextStyle.body3Regular()),
            ],
          ),
        ),
        const Spacer(),
        Text("내역 조회", style: FortuneTextStyle.body3Regular(fontColor: ColorName.activeDark)),
        const SizedBox(width: 4),
        Assets.icons.icArrowRight12.svg(width: 12, height: 12),
      ],
    );
  }
}
