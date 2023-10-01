import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:fortune/core/gen/colors.gen.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/core/util/textstyle.dart';
import 'package:fortune/core/widgets/button/fortune_scale_button.dart';
import 'package:fortune/domain/supabase/entity/fortune_user_entity.dart';
import 'package:fortune/domain/supabase/entity/mission/mission_reward_entity.dart';
import 'package:transparent_image/transparent_image.dart';

class ExchangeBottom extends StatelessWidget {
  const ExchangeBottom({
    super.key,
    required this.user,
    required this.onExchangeClick,
    required this.entity,
  });

  final Function0 onExchangeClick;
  final MissionRewardEntity entity;
  final FortuneUserEntity user;

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
          const SizedBox(height: 32),
          Text(
            entity.rewardName,
            textAlign: TextAlign.center,
            style: FortuneTextStyle.headLine2(),
          ),
          const SizedBox(height: 16),
          Text(
            user.phone,
            textAlign: TextAlign.center,
            style: FortuneTextStyle.body3Light(color: ColorName.grey400),
          ),
          const SizedBox(height: 16),
          Text(
            FortuneTr.msgRewardRedemptionNotice,
            textAlign: TextAlign.center,
            style: FortuneTextStyle.body1Light(color: ColorName.grey200, height: 1.5),
          ),
          const SizedBox(height: 40),
          FortuneScaleButton(
            isEnabled: true,
            onPress: onExchangeClick,
            text: FortuneTr.msgExchange,
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
