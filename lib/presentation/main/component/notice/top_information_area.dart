import 'package:add_to_cart_animation/add_to_cart_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foresh_flutter/core/gen/assets.gen.dart';
import 'package:foresh_flutter/core/gen/colors.gen.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';
import 'package:foresh_flutter/domain/supabase/entity/fortune_user_grade_entity.dart';
import 'package:foresh_flutter/presentation/main/bloc/main.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class TopInformationArea extends StatelessWidget {
  final MainBloc _bloc;
  final GlobalKey<CartIconKey> _cartKey;

  const TopInformationArea(
    this._bloc,
    this._cartKey, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 레벨 프로그레스.
        Flexible(
          child: BlocBuilder<MainBloc, MainState>(
            buildWhen: (previous, current) => previous.user?.percentageNextLevel != current.user?.percentageNextLevel,
            builder: (context, state) {
              final user = state.user;
              return user != null
                  ? _UserLevel(
                      user.grade,
                      user.percentageNextLevel,
                      user.level,
                    )
                  : const SizedBox.shrink();
            },
          ),
        ),
        const SizedBox(width: 10),
        // 티켓 카운트.
        BlocBuilder<MainBloc, MainState>(
          buildWhen: (previous, current) => previous.user?.ticket != current.user?.ticket,
          builder: (context, state) {
            final user = state.user;
            return user != null ? _TicketCount(user.ticket) : const SizedBox.shrink();
          },
        ),
        const SizedBox(width: 10),
        // 마커 획득갯수.
        BlocBuilder<MainBloc, MainState>(
          buildWhen: (previous, current) => previous.user?.markerObtainCount != current.user?.markerObtainCount,
          builder: (context, state) {
            final user = state.user;
            return user != null ? _ObtainMarkerCount(_cartKey, user.markerObtainCount) : const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}

class _ObtainMarkerCount extends StatelessWidget {
  final GlobalKey<CartIconKey> _cartKey;
  final int? _markerObtainCount;

  const _ObtainMarkerCount(
    this._cartKey,
    this._markerObtainCount, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 12, top: 8, bottom: 8),
      decoration: BoxDecoration(
        color: ColorName.backgroundLight,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Assets.icons.icIngredientBag.svg(width: 20, height: 20),
          AddToCartIcon(
            key: _cartKey,
            badgeOptions: const BadgeOptions(active: false),
            icon: Text(
              "$_markerObtainCount",
              style: FortuneTextStyle.body3Bold(),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: ColorName.deActive,
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Assets.icons.icPlus.svg(width: 8, height: 8),
          )
        ],
      ),
    );
    // return AddToCartIcon(
    //   key: _cartKey,
    //   badgeOptions: const BadgeOptions(active: false),
    //   icon:
    // );
  }
}

class _TicketCount extends StatelessWidget {
  final int? _ticket;

  const _TicketCount(
    this._ticket, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 12, top: 8, bottom: 8),
      decoration: BoxDecoration(
        color: ColorName.backgroundLight,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Assets.icons.icFortuneMoney.svg(width: 20, height: 20),
          const SizedBox(width: 8),
          Text("$_ticket", style: FortuneTextStyle.body3Bold())
        ],
      ),
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
    this._level, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 8, top: 8, bottom: 8),
      decoration: BoxDecoration(
        color: ColorName.backgroundLight,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          _grade.icon.svg(width: 20, height: 20),
          const SizedBox(width: 10),
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Stack(
                children: [
                  LinearPercentIndicator(
                    width: 87,
                    animation: false,
                    lineHeight: 20,
                    animationDuration: 2000,
                    percent: _percentageNextLevel ?? 0,
                    padding: const EdgeInsets.all(0),
                    barRadius: Radius.circular(100.r),
                    backgroundColor: ColorName.deActive.withOpacity(0.3),
                    progressColor: ColorName.secondary,
                  ),
                  Positioned.fill(
                    child: Center(
                      child: Text(
                        "Lv. $_level",
                        style: FortuneTextStyle.caption1SemiBold(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
