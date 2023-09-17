import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:foresh_flutter/core/gen/colors.gen.dart';
import 'package:foresh_flutter/core/widgets/bottomsheet/bottom_sheet_ext.dart';
import 'package:foresh_flutter/core/widgets/button/fortune_scale_button.dart';
import 'package:foresh_flutter/domain/supabase/entity/mission/mission_detail_entity.dart';
import 'package:foresh_flutter/presentation/missiondetail/bloc/mission_detail_state.dart';

import '../../../core/util/textstyle.dart';
import 'exchange_bottom.dart';
import 'ingredient_layout.dart';

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
                      style: FortuneTextStyle.body1Light(fontColor: ColorName.grey200),
                    ),
                  ),
                  const SizedBox(height: 40),
                  IngredientLayout(state.entity.markers),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      state.entity.mission.note,
                      style: FortuneTextStyle.body1Semibold(fontColor: ColorName.grey200),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      state.entity.mission.missionReward.note,
                      style: FortuneTextStyle.body1Light(fontColor: ColorName.grey200),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 50,
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
            text: "교환하기",
            press: () => _showExchangeBottomSheet(context, state.entity),
          ),
        ),
      ],
    );
  }

  _showExchangeBottomSheet(BuildContext context, MissionDetailEntity entity) {
    context.showFortuneBottomSheet(
      content: (context) {
        return ExchangeBottom(
          onExchangeClick: onExchangeClick,
          entity: entity.mission.missionReward,
        );
      },
    );
  }
}
