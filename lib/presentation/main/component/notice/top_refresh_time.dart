import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foresh_flutter/core/gen/assets.gen.dart';
import 'package:foresh_flutter/core/gen/colors.gen.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';
import 'package:foresh_flutter/di.dart';
import 'package:foresh_flutter/presentation/fortune_router.dart';

import '../../bloc/main.dart';

class TopRefreshTime extends StatefulWidget {
  final MainBloc bloc;

  const TopRefreshTime(
    this.bloc, {
    super.key,
  });

  @override
  State<TopRefreshTime> createState() => _TopRefreshTimeState();
}

class _TopRefreshTimeState extends State<TopRefreshTime> with TickerProviderStateMixin {
  late AnimationController controller;
  final router = serviceLocator<FortuneRouter>().router;

  String get _timerString {
    Duration duration = controller.duration! * controller.value;
    int day = duration.inDays;
    int hour = duration.inHours % 24;
    int minutes = duration.inMinutes % 60;
    int seconds = duration.inSeconds % 60; // 초를 구하는 코드 추가
    String secondStr = seconds >= 10 ? seconds.toString() : seconds.toString().padLeft(1, ' ');
    return '$secondStr초 후에 새로고침';
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
      listenWhen: (previous, current) => previous.refreshCount != current.refreshCount,
      listener: (context, state) {
        controller.dispose();
        controller = AnimationController(
          vsync: this,
          duration: Duration(seconds: state.refreshTime),
        );
        controller.reverse(from: controller.value == 0.0 ? 1.0 : controller.value);
        controller.addListener(() {
          if (controller.value == 0) {
            widget.bloc.add(MainTimeOver());
          }
        });
      },
      buildWhen: (previous, current) => previous.refreshCount != current.refreshCount,
      builder: (context, state) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 6, right: 12, top: 6, bottom: 6),
              decoration: BoxDecoration(
                color: ColorName.backgroundLight,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: BlocBuilder<MainBloc, MainState>(
                buildWhen: (previous, current) => previous.ticketCount != current.ticketCount,
                builder: (context, state) {
                  return Row(
                    children: [
                      Assets.icons.icFortuneTicket.svg(width: 24, height: 24),
                      const SizedBox(width: 8),
                      Text("${state.ticketCount}", style: FortuneTextStyle.body3Bold())
                    ],
                  );
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: 6, right: 8, top: 6, bottom: 6),
                decoration: BoxDecoration(
                  color: ColorName.backgroundLight,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    Assets.icons.icTimer.svg(width: 24, height: 24),
                    SizedBox(width: 8),
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
                                  padding: const EdgeInsets.symmetric(vertical: 2.0),
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
                                      color: animationValue == 0.0
                                          ? Colors.transparent
                                          : animationValue > 0.2
                                              ? ColorName.positive
                                              : ColorName.primary,
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 2.0),
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
                                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                                  child: Text(
                                    controller.value <= 0.01 ? "새로운 마커들을 불러오는 중 " : _timerString,
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
        );
      },
    );
  }
}
