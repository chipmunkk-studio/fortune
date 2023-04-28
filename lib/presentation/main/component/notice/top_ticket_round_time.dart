import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foresh_flutter/core/gen/assets.gen.dart';
import 'package:foresh_flutter/core/gen/colors.gen.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';

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
  Widget build(BuildContext context) {
    return BlocConsumer<MainBloc, MainState>(
      listenWhen: (previous, current) => previous.roundTime != current.roundTime,
      listener: (context, state) {
        controller = AnimationController(
          vsync: this,
          duration: Duration(seconds: state.roundTime),
          // duration: Duration(seconds: 10),
        );
        controller.reverse(from: controller.value == 0.0 ? 1.0 : controller.value);
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
                            Assets.icons.fortuneTicket.svg(width: 24.w, height: 24.h),
                            SizedBox(width: 8.w),
                            Text("${state.normalTicketCnt}", style: FortuneTextStyle.body3Bold())
                          ],
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Container(
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
                            Assets.icons.fortuneMoney.svg(width: 24.w, height: 24.h),
                            SizedBox(width: 8.w),
                            Text("${state.chargeTicketCnt}", style: FortuneTextStyle.body3Bold()),
                            SizedBox(
                              width: 8.w,
                            ),
                            Assets.icons.fortuneMoneyPlus.svg(width: 16.w, height: 16.h),
                          ],
                        );
                      },
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
                          Assets.icons.timer.svg(width: 24.w, height: 24.h),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Stack(
                              children: [
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: ColorName.deActiveDark,
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 2.0.h),
                                    child: Text("", style: FortuneTextStyle.caption1SemiBold()),
                                  ),
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
                                            color: animationValue == 0.0 || animationValue > 0.7
                                                ? ColorName.deActive
                                                : animationValue > 0.5
                                                    ? ColorName.positive
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
                                          _timerString,
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
