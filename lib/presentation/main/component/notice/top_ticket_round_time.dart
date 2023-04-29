import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foresh_flutter/core/gen/assets.gen.dart';
import 'package:foresh_flutter/core/gen/colors.gen.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';
import 'package:foresh_flutter/core/widgets/animation/scale_widget.dart';
import 'package:foresh_flutter/di.dart';
import 'package:foresh_flutter/presentation/fortune_router.dart';

import '../../bloc/main.dart';

class TopTicketRoundTime extends StatefulWidget {
  final MainBloc bloc;

  const TopTicketRoundTime(
    this.bloc, {
    super.key,
  });

  @override
  State<TopTicketRoundTime> createState() => _TopTicketRoundTimeState();
}

class _TopTicketRoundTimeState extends State<TopTicketRoundTime> with TickerProviderStateMixin {
  late AnimationController controller;
  final router = serviceLocator<FortuneRouter>().router;

  String get _timerString {
    Duration duration = controller.duration! * controller.value;
    int day = duration.inDays;
    int hour = duration.inHours % 24;
    int minutes = duration.inMinutes % 60;
    return '${day.toString().padLeft(2, '0')}:'
        '${hour.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    // vsync때문에 여기에 초기화함.
    controller = AnimationController(
      duration: const Duration(seconds: 0),
      vsync: this,
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainBloc, MainState>(
      listenWhen: (previous, current) => previous.roundTime != current.roundTime,
      listener: (context, state) {
        controller.dispose();
        controller = AnimationController(
          vsync: this,
          duration: Duration(seconds: state.roundTime),
        );
        controller.reverse(from: controller.value == 0.0 ? 1.0 : controller.value);
        controller.addListener(() {
          if (controller.value == 0) {
            widget.bloc.add(MainRoundOver());
            controller.dispose();
          }
        });
      },
      buildWhen: (previous, current) => previous.roundTime != current.roundTime,
      builder: (context, state) {
        return state.roundTime > 0
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 6.w, right: 12.w, top: 6.h, bottom: 6.h),
                    decoration: BoxDecoration(
                      color: ColorName.backgroundLight,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: BlocBuilder<MainBloc, MainState>(
                      buildWhen: (previous, current) => previous.normalTicketCnt != current.normalTicketCnt,
                      builder: (context, state) {
                        return Row(
                          children: [
                            Assets.icons.icFortuneTicket.svg(width: 24.w, height: 24.h),
                            SizedBox(width: 8.w),
                            Text("${state.normalTicketCnt}", style: FortuneTextStyle.body3Bold())
                          ],
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 10.w),
                  ScaleWidget(
                    onTapUp: () async {
                      await router.navigateTo(context, Routes.storeRoute);
                      widget.bloc.add(MainRefresh());
                    },
                    child: Container(
                      padding: EdgeInsets.only(left: 6.w, right: 8.w, top: 6.h, bottom: 6.h),
                      decoration: BoxDecoration(
                        color: ColorName.backgroundLight,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: BlocBuilder<MainBloc, MainState>(
                        buildWhen: (previous, current) => previous.chargeTicketCnt != current.chargeTicketCnt,
                        builder: (context, state) {
                          return Row(
                            children: [
                              Assets.icons.icFortuneMoney.svg(width: 24.w, height: 24.h),
                              SizedBox(width: 8.w),
                              Text("${state.chargeTicketCnt}", style: FortuneTextStyle.body3Bold()),
                              SizedBox(
                                width: 8.w,
                              ),
                              Assets.icons.icFortuneMoneyPlus.svg(width: 16.w, height: 16.h),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: 6.w, right: 8.w, top: 6.h, bottom: 6.h),
                      decoration: BoxDecoration(
                        color: ColorName.backgroundLight,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        children: [
                          Assets.icons.icTimer.svg(width: 24.w, height: 24.h),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Stack(
                              children: [
                                AnimatedBuilder(
                                  animation: controller,
                                  builder: (context, child) {
                                    return Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: ColorName.deActiveDark,
                                        borderRadius: BorderRadius.circular(12.r),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(vertical: 2.0.h),
                                        child: Text("", style: FortuneTextStyle.caption1SemiBold()),
                                      ),
                                    );
                                  },
                                ),
                                LayoutBuilder(
                                  builder: (context, constraints) {
                                    return AnimatedBuilder(
                                      animation: controller,
                                      builder: (context, child) {
                                        final animationValue = controller.value;
                                        return Container(
                                          width: controller.value == 0
                                              ? constraints.maxWidth
                                              : constraints.maxWidth * controller.value,
                                          decoration: BoxDecoration(
                                            color: animationValue == 0.0 || animationValue > 0.2
                                                ? ColorName.deActive
                                                : ColorName.negative,
                                            borderRadius: BorderRadius.circular(12.r),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(vertical: 2.0.h),
                                            child: Text("", style: FortuneTextStyle.caption1SemiBold()),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                                AnimatedBuilder(
                                  animation: controller,
                                  builder: (BuildContext context, Widget? child) {
                                    return Container(
                                      alignment: Alignment.center,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(vertical: 2.0.h),
                                        child: Text(
                                          controller.value <= 0.01 ? "라운드 집계중" : _timerString,
                                          overflow: TextOverflow.ellipsis,
                                          style: FortuneTextStyle.caption1SemiBold(),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : const SizedBox.shrink();
      },
    );
  }
}
