import 'dart:async';

import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fortune/core/gen/assets.gen.dart';
import 'package:fortune/core/gen/colors.gen.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/core/util/textstyle.dart';
import 'package:fortune/core/widgets/animation/linear_bounce_animation.dart';
import 'package:fortune/core/widgets/button/fortune_scale_button.dart';
import 'package:fortune/core/widgets/fortune_scaffold.dart';

class CustomerAdView extends StatefulWidget {
  final dartz.Function0 onPressed;

  const CustomerAdView({
    super.key,
    required this.onPressed,
  });

  @override
  State<CustomerAdView> createState() => _CustomerAdViewState();
}

class _CustomerAdViewState extends State<CustomerAdView> {
  bool isButtonEnabled = false;
  String buttonText = FortuneTr.msgButtonActivationCountdown(5);

  final String _content = "본 공고에서 궁금하신 점이나 광고 요청은\n"
      "chipmunkk.studio@gmailcom으로 연락주세요.\n"
      "광고에 필요한 디자인은 포춘레이더가\n"
      "추가 비용 없이 무료로 만들어드립니다.";

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (
      Timer timer,
    ) {
      if (timer.tick >= 5) {
        setState(() {
          isButtonEnabled = true;
          buttonText = FortuneTr.msgScratchToReveal;
        });
        timer.cancel();
      } else {
        setState(() {
          buttonText = FortuneTr.msgButtonActivationCountdown(5 - timer.tick);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FortuneScaffold(
      bottom: false,
      top: false,
      padding: EdgeInsets.zero,
      backgroundColor: ColorName.grey900,
      child: Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Assets.images.customerAdCi.svg(),
                  const SizedBox(height: 40),
                  Text(
                    '사장님\n이자리에 광고해요!',
                    style: FortuneTextStyle.headLine1(height: 1.4),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '광고가 필요하신 모든 분들에게\n부담 없는 가격으로 광고를 제공해드려요.',
                    style: FortuneTextStyle.body2Regular(
                      height: 1.5,
                      color: ColorName.grey200,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 36),
                  LinearBounceAnimation(
                    child: Assets.images.customerAd.image(
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 33),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      color: ColorName.grey800,
                    ),
                    child: Text(
                      _content,
                      style: FortuneTextStyle.body3Regular(
                        height: 1.3,
                        color: ColorName.grey200,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 40, // 버튼의 아래쪽 여백 설정
            left: 16, // 버튼의 왼쪽 여백 설정
            right: 16, // 버튼의 오른쪽 여백 설정
            child: Column(
              children: [
                Container(
                  height: 30,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        ColorName.grey900.withOpacity(1.0),
                        ColorName.grey900.withOpacity(0.0),
                      ],
                    ),
                  ),
                ),
                FortuneScaleButton(
                  text: buttonText,
                  isEnabled: isButtonEnabled,
                  onPress: widget.onPressed,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
