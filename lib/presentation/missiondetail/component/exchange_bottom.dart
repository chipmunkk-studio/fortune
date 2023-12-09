import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:fortune/core/gen/colors.gen.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/core/util/textstyle.dart';
import 'package:fortune/core/widgets/button/fortune_scale_button.dart';
import 'package:fortune/core/widgets/fortune_cached_network_Image.dart';
import 'package:fortune/data/supabase/service_ext.dart';
import 'package:fortune/domain/supabase/entity/fortune_user_entity.dart';
import 'package:fortune/domain/supabase/entity/mission/mission_reward_entity.dart';

class ExchangeBottom extends StatelessWidget {
  const ExchangeBottom({
    super.key,
    required this.user,
    required this.isButtonEnabled,
    required this.onExchangeClick,
    required this.entity,
  });

  final Function0 onExchangeClick;
  final MissionRewardEntity entity;
  final FortuneUserEntity user;
  final bool isButtonEnabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          _buildMissionRewardImage(entity),
          const SizedBox(height: 32),
          Text(
            entity.name,
            textAlign: TextAlign.center,
            style: FortuneTextStyle.headLine2(),
          ),
          const SizedBox(height: 16),
          Text(
            user.email,
            textAlign: TextAlign.center,
            style: FortuneTextStyle.body3Regular(color: ColorName.grey400),
          ),
          const SizedBox(height: 16),
          Text(
            FortuneTr.msgRewardRedemptionNotice,
            textAlign: TextAlign.center,
            style: FortuneTextStyle.body1Regular(color: ColorName.grey200, height: 1.5),
          ),
          const SizedBox(height: 40),
          FortuneScaleButton(
            isEnabled: isButtonEnabled,
            onPress: onExchangeClick,
            text: FortuneTr.msgExchange,
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  _buildMissionRewardImage(MissionRewardEntity entity) {
    switch (entity.type) {
      case RewardImageType.rectangle:
        return ClipRect(
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: FortuneCachedNetworkImage(
              imageUrl: entity.image,
              placeholder: Container(),
            ),
          ),
        );
      default:
        return SizedBox.square(
          dimension: 128,
          child: FortuneCachedNetworkImage(
            imageUrl: entity.image,
            placeholder: Container(),
            imageShape: ImageShape.circle,
          ),
        );
    }
  }
}
