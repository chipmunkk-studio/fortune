import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foresh_flutter/core/gen/assets.gen.dart';
import 'package:foresh_flutter/core/gen/colors.gen.dart';
import 'package:foresh_flutter/core/widgets/bottomsheet/bottom_sheet_ext.dart';
import 'package:foresh_flutter/core/widgets/button/fortune_bottom_button.dart';
import 'package:foresh_flutter/core/widgets/painter/squircle_painter.dart';
import 'package:foresh_flutter/domain/supabase/entity/mission/mission_detail_entity.dart';
import 'package:foresh_flutter/presentation/missiondetail/bloc/mission_detail_state.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../../core/util/textstyle.dart';

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
                      style: FortuneTextStyle.subTitle1SemiBold(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      state.entity.mission.content,
                      style: FortuneTextStyle.body1Regular(fontColor: ColorName.activeDark),
                    ),
                  ),
                  const SizedBox(height: 40),
                  _IngredientLayout(state.entity.markers),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      state.entity.mission.content,
                      style: FortuneTextStyle.body1Regular(fontColor: ColorName.activeDark),
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
                        ColorName.background.withOpacity(1.0),
                        ColorName.background.withOpacity(0.0),
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
          child: FortuneBottomButton(
            isEnabled: state.isEnableButton,
            buttonText: "교환하기",
            onPress: () => _showExchangeBottomSheet(context),
            isKeyboardVisible: false,
          ),
        ),
      ],
    );
  }

  _showExchangeBottomSheet(BuildContext context) {
    context.showFortuneBottomSheet(
      content: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "스타벅스 아이스 카페 아메리카노",
                style: FortuneTextStyle.headLine1(),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                "50개가 차감되며, 회원정보에 등록된 휴대폰 메세지로 모바일 상품권이 발송됩니다. 지금받으시겠습니까?",
                textAlign: TextAlign.center,
                style: FortuneTextStyle.body2Regular(),
              ),
              const SizedBox(height: 16),
              FortuneBottomButton(
                isEnabled: true,
                onPress: onExchangeClick,
                buttonText: "교환",
                isKeyboardVisible: false,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _IngredientLayout extends StatelessWidget {
  final List<MissionDetailViewItemEntity> _viewItems;

  const _IngredientLayout(
    this._viewItems, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return _viewItems.isNotEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(width: 20.w),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _buildIngredient(_viewItems[0]),
                    SizedBox(width: 26.h),
                    _buildIngredient(_viewItems[1]),
                  ],
                ),
                SizedBox(height: 28.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    _buildIngredient(_viewItems[2]),
                    _buildIngredient(_viewItems[3]),
                    _buildIngredient(_viewItems[4]),
                  ],
                ),
                SizedBox(height: 28.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _buildIngredient(_viewItems[5]),
                    SizedBox(width: 26.h),
                    _buildIngredient(_viewItems[6]),
                  ],
                ),
              ],
            ),
          )
        : const SizedBox.shrink();
  }

  Widget _buildIngredient(MissionDetailViewItemEntity item) {
    return Stack(
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: 148.h,
            minHeight: 148.h,
            maxWidth: 100.h,
            minWidth: 100.h,
          ),
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: 1.0,
                child: CustomPaint(
                  painter: SquirclePainter(color: ColorName.backgroundLight),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: item.isEmpty
                        ? Assets.icons.icLock.svg(
                            width: 68.h,
                            height: 68.h,
                          )
                        : FadeInImage.memoryNetwork(
                            width: 68.h,
                            height: 68.h,
                            placeholder: kTransparentImage,
                            image: item.ingredient.imageUrl,
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Align(
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 7.h, horizontal: 10.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                    color: ColorName.backgroundLight,
                    border: Border.all(
                      color: ColorName.background,
                      width: 2.h,
                    ),
                  ),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "${item.haveCount}",
                          style: FortuneTextStyle.caption1SemiBold(fontColor: ColorName.primary),
                        ),
                        TextSpan(
                          text: "/${item.requireCount}",
                          style: FortuneTextStyle.caption1SemiBold(fontColor: ColorName.deActive),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  item.ingredient.name.isEmpty ? '-' : item.ingredient.name,
                  style: FortuneTextStyle.body3Regular(),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
