import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fortune/core/gen/colors.gen.dart';
import 'package:fortune/core/util/textstyle.dart';
import 'package:fortune/core/widgets/button/fortune_scale_button.dart';
import 'package:fortune/domain/supabase/entity/mission/mission_reward_entity.dart';
import 'package:transparent_image/transparent_image.dart';

class ExchangeBottom extends StatelessWidget {
  const ExchangeBottom({
    super.key,
    required this.onExchangeClick,
    required this.entity,
  });

  final Function0 onExchangeClick;
  final MissionRewardEntity entity;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox.square(
            dimension: 128,
            child: ClipOval(
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: entity.rewardImage,
              ),
            ),
          ),
          const SizedBox(height: 40),
          Container(
            decoration: BoxDecoration(
              color: ColorName.grey700,
              borderRadius: BorderRadius.circular(6.r),
            ),
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
            child: Text(
              entity.rewardName,
              style: FortuneTextStyle.caption3Semibold(),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "상품을 수령하시겠어요?",
            textAlign: TextAlign.center,
            style: FortuneTextStyle.headLine2(),
          ),
          const SizedBox(height: 14),
          Text(
            "가입 시 인증한 핸드폰 번호로\n교환 쿠폰이 전송됩니다.",
            textAlign: TextAlign.center,
            style: FortuneTextStyle.body3Light(fontColor: ColorName.grey200),
          ),
          const SizedBox(height: 16),
          FortuneScaleButton(
            isEnabled: true,
            press: onExchangeClick,
            text: "교환",
          ),
        ],
      ),
    );
  }
}
