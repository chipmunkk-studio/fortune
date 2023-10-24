import 'package:add_to_cart_animation/add_to_cart_icon.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fortune/core/gen/assets.gen.dart';
import 'package:fortune/core/gen/colors.gen.dart';
import 'package:fortune/core/util/textstyle.dart';
import 'package:fortune/domain/supabase/entity/fortune_user_grade_entity.dart';
import 'package:fortune/presentation/main/bloc/main.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:skeletons/skeletons.dart';

class TopInformationArea extends StatelessWidget {
  final GlobalKey<CartIconKey> _cartKey;
  final Function0 onInventoryTap;
  final Function0 onGradeAreaTap;
  final Function0 onCoinTap;

  const TopInformationArea(
    this._cartKey, {
    super.key,
    required this.onInventoryTap,
    required this.onGradeAreaTap,
    required this.onCoinTap,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      buildWhen: (previous, current) => previous.isLoading != current.isLoading,
      builder: (context, state) {
        return Skeleton(
          isLoading: state.isLoading,
          skeleton: const SizedBox.shrink(),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 레벨 프로그레스.
              Flexible(
                child: BlocBuilder<MainBloc, MainState>(
                  buildWhen: (previous, current) =>
                      previous.user?.nextLevelInfo.nextLevelMarkerCount !=
                      current.user?.nextLevelInfo.nextLevelMarkerCount,
                  builder: (context, state) {
                    final user = state.user;
                    return user != null
                        ? Bounceable(
                            onTap: onGradeAreaTap,
                            child: _UserLevel(
                              user.grade,
                              user.nextLevelInfo.progressToNextLevelPercentage,
                              user.level,
                            ),
                          )
                        : const SizedBox.shrink();
                  },
                ),
              ),
              const SizedBox(width: 10),
              // 티켓 카운트.
              BlocBuilder<MainBloc, MainState>(
                buildWhen: (previous, current) => previous.user?.ticket != current.user?.ticket,
                builder: (context, state) => Bounceable(
                  onTap: onCoinTap,
                  child: _CoinCount(state.user?.ticket ?? 0),
                ),
              ),
              const SizedBox(width: 10),
              // 마커 획득 갯수.
              BlocBuilder<MainBloc, MainState>(
                buildWhen: (previous, current) => previous.haveCount != current.haveCount,
                builder: (context, state) => Bounceable(
                  onTap: onInventoryTap,
                  child: _ObtainMarkerCount(
                    _cartKey,
                    state.haveCount,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _UserLevel extends StatelessWidget {
  final double? _percentageNextLevel;
  final int? _level;
  final FortuneUserGradeEntity _grade;

  const _UserLevel(
    this._grade,
    this._percentageNextLevel,
    this._level,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorName.grey700,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 5, bottom: 5),
            child: _grade.icon.svg(width: 20, height: 20),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return FittedBox(
                  fit: BoxFit.scaleDown,
                  child: LinearPercentIndicator(
                    width: constraints.maxWidth,
                    animation: false,
                    lineHeight: 16,
                    animationDuration: 2000,
                    center: Text(
                      "Lv. $_level",
                      style: FortuneTextStyle.caption3Semibold(),
                    ),
                    percent: _percentageNextLevel ?? 0,
                    padding: const EdgeInsets.all(0),
                    barRadius: Radius.circular(100.r),
                    linearGradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.topRight,
                      colors: [
                        ColorName.primary,
                        ColorName.secondary,
                      ],
                    ),
                    backgroundColor: ColorName.grey500,
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}

class _CoinCount extends StatelessWidget {
  final int? _ticket;

  const _CoinCount(
    this._ticket,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorName.grey700,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 5, bottom: 5),
            child: Assets.icons.icFortuneMoney.svg(width: 20, height: 20),
          ),
          const SizedBox(width: 8),
          Text("$_ticket", style: FortuneTextStyle.body3Semibold()),
          const SizedBox(width: 12),
        ],
      ),
    );
  }
}

class _ObtainMarkerCount extends StatelessWidget {
  final GlobalKey<CartIconKey> _cartKey;
  final int? _markerObtainCount;

  const _ObtainMarkerCount(
    this._cartKey,
    this._markerObtainCount,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorName.grey700,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, top: 5, bottom: 5),
            child: Assets.icons.icIngredientBag.svg(width: 20, height: 20),
          ),
          AddToCartIcon(
            key: _cartKey,
            badgeOptions: const BadgeOptions(active: false),
            icon: Text(
              "$_markerObtainCount",
              style: FortuneTextStyle.body3Semibold(),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: ColorName.grey500,
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Assets.icons.icPlus.svg(width: 8, height: 8),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}
