import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return '$secondStr';
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
        return state.refreshCount != 0
            ? Row(
                children: [
                  Stack(
                    children: [
                      AnimatedBuilder(
                        animation: controller,
                        builder: (BuildContext context, Widget? child) {
                          return CircularProgressIndicator(
                            value: controller.value, // 진행률을 결정합니다.
                            backgroundColor: ColorName.deActiveDark,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              controller.value == 0.0
                                  ? Colors.transparent
                                  : controller.value > 0.5
                                      ? Colors.white
                                      : ColorName.primary,
                            ),
                          );
                        },
                      ),
                      Positioned.fill(
                        child: AnimatedBuilder(
                          animation: controller,
                          builder: (BuildContext context, Widget? child) => Center(
                            child: Text(
                              _timerString,
                              style: FortuneTextStyle.body3Bold(),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(width: 10),
                  AnimatedBuilder(
                    animation: controller,
                    builder: (BuildContext context, Widget? child) {
                      return controller.value < 0.4
                          ? Text(
                              "$_timerString초 후 새로고침",
                              style: FortuneTextStyle.body3Bold(),
                            )
                          : const SizedBox.shrink();
                    },
                  ),
                ],
              )
            : const SizedBox.shrink();
      },
    );
  }
}
