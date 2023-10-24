import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:fortune/core/gen/colors.gen.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/core/widgets/bottomsheet/bottom_sheet_ext.dart';
import 'package:fortune/core/widgets/button/fortune_scale_button.dart';
import 'package:fortune/domain/supabase/entity/mission/mission_detail_entity.dart';
import 'package:fortune/presentation/missiondetail/bloc/mission_detail_state.dart';

import '../../../../core/util/textstyle.dart';
import '../exchange_bottom.dart';
import '../ingredient_layout.dart';

class NormalMission extends StatelessWidget {
  final MissionDetailState state;
  final Function0 onExchangeClick;

  const NormalMission(
    this.state, {
    Key? key,
    required this.onExchangeClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      state.entity.mission.title,
                      style: FortuneTextStyle.headLine2(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      state.entity.mission.content,
                      style: FortuneTextStyle.body1Light(
                        color: ColorName.grey200,
                        height: 1.3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  IngredientLayout(state.entity.markers),
                  const SizedBox(height: 44),
                  const Divider(height: 16, thickness: 16, color: ColorName.grey800),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(FortuneTr.msgMissionGuide, style: FortuneTextStyle.body2Semibold()),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      state.entity.mission.note,
                      style: FortuneTextStyle.body3Light(color: ColorName.grey200, height: 1.4),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(FortuneTr.msgRewardGuide, style: FortuneTextStyle.body2Semibold()),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      state.entity.mission.reward.note,
                      style: FortuneTextStyle.body3Light(color: ColorName.grey200, height: 1.4),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(FortuneTr.msgCaution, style: FortuneTextStyle.body2Semibold()),
                  ),
                  const SizedBox(height: 12),
                  _buildCaution(),
                  const SizedBox(height: 40),
                ],
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 20,
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
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16, left: 20, right: 20),
          child: FortuneScaleButton(
            isEnabled: true,
            text: FortuneTr.msgExchange,
            onPress: () => _showExchangeBottomSheet(
              context,
              entity: state.entity,
              isEnableButton: state.isEnableButton,
            ),
          ),
        ),
      ],
    );
  }

  // 주의 사항.
  Padding _buildCaution() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            FortuneTr.msgMissionEarlyEnd,
            style: FortuneTextStyle.body3Light(color: ColorName.grey200, height: 1.4),
          ),
          Text(
            FortuneTr.msgUnfairParticipation,
            style: FortuneTextStyle.body3Light(color: ColorName.grey200, height: 1.4),
          ),
        ],
      ),
    );
  }

  _showExchangeBottomSheet(
    BuildContext context, {
    required MissionDetailEntity entity,
    required bool isEnableButton,
  }) {
    context.showBottomSheet(
      content: (context) {
        return ExchangeBottom(
          onExchangeClick: onExchangeClick,
          entity: entity.mission.reward,
          isButtonEnabled: isEnableButton,
          user: entity.user,
        );
      },
    );
  }
}
