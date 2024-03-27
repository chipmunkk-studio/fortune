import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:fortune/core/gen/colors.gen.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/core/util/textstyle.dart';
import 'package:fortune/core/widgets/button/fortune_scale_button.dart';
import 'package:fortune/core/widgets/fortune_cached_network_Image.dart';
import 'package:fortune/domain/entity/reward_info_entity.dart';

class ExchangeBottom extends StatelessWidget {
  const ExchangeBottom({
    super.key,
    required this.isButtonEnabled,
    required this.onExchangeClick,
    required this.entity,
  });

  final Function0 onExchangeClick;
  final RewardInfoEntity entity;
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
          // _buildMissionRewardImage(entity.image.url),
          const SizedBox(height: 32),
          Text(
            entity.title,
            textAlign: TextAlign.center,
            style: FortuneTextStyle.headLine2(),
          ),
          const SizedBox(height: 16),
          Text(
            "유저 이메일 있어야 함. ",
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

  _buildMissionRewardImage(String url) {
    return SizedBox.square(
      dimension: 128,
      child: FortuneCachedNetworkImage(
        imageUrl: url,
        placeholder: Container(),
        imageShape: ImageShape.circle,
      ),
    );
    // todo 리워드 이미지 타입.
    // switch (entity.type) {
    //   case RewardImageType.rectangle:
    //     return ClipRect(
    //       child: AspectRatio(
    //         aspectRatio: 16 / 9,
    //         child: FortuneCachedNetworkImage(
    //           imageUrl: entity.image,
    //           placeholder: Container(),
    //         ),
    //       ),
    //     );
    //   default:
    //     return SizedBox.square(
    //       dimension: 128,
    //       child: FortuneCachedNetworkImage(
    //         imageUrl: entity.image,
    //         placeholder: Container(),
    //         imageShape: ImageShape.circle,
    //       ),
    //     );
    // }
  }
}
