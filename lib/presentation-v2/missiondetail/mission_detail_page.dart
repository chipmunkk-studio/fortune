import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortune/core/gen/colors.gen.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/core/navigation/fortune_app_router.dart';
import 'package:fortune/core/util/mixpanel.dart';
import 'package:fortune/core/widgets/fortune_scaffold.dart';
import 'package:fortune/di.dart';
import 'package:fortune/domain/entity/mission_entity.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';
import 'package:skeletons/skeletons.dart';

import 'bloc/mission_detail.dart';
import 'component/mission/normal_mission.dart';
import 'component/skeleton.dart';
import 'mission_detail_param.dart';

class MissionDetailPage extends StatelessWidget {
  const MissionDetailPage(
    this.param, {
    super.key,
  });

  final MissionDetailParam param;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<MissionDetailBloc>()..add(MissionDetailInit(param)),
      child: const _MissionDetailPage(),
    );
  }
}

class _MissionDetailPage extends StatefulWidget {
  const _MissionDetailPage();

  @override
  State<_MissionDetailPage> createState() => _MissionDetailPageState();
}

class _MissionDetailPageState extends State<_MissionDetailPage> {
  late final MissionDetailBloc _bloc;
  final router = serviceLocator<FortuneAppRouter>().router;

  final MixpanelTracker tracker = serviceLocator<MixpanelTracker>();
  final ConfettiController _controller = ConfettiController(
    duration: const Duration(
      seconds: 2,
    ),
  );

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<MissionDetailBloc>(context);
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSideEffectListener<MissionDetailBloc, MissionDetailSideEffect>(
      listener: (context, sideEffect) {
        if (sideEffect is MissionDetailAcquireSuccess) {
          dialogService2.showFortuneDialog(
            context,
            title: FortuneTr.msgMissionCompleted,
            subTitle: FortuneTr.msgPaymentDelay,
            btnOkText: FortuneTr.confirm,
            btnOkPressed: () {
              router.pop(context);
            },
          );
        } else if (sideEffect is MissionDetailError) {
          dialogService2.showAppErrorDialog(context, sideEffect.error);
        } else if (sideEffect is MissionDetailParticleBurst) {
          _controller.play();
        }
      },
      child: Stack(
        children: [
          BlocBuilder<MissionDetailBloc, MissionDetailState>(
            builder: (context, state) {
              return FortuneScaffold(
                padding: const EdgeInsets.all(0),
                appBar: FortuneCustomAppBar.leadingAppBar(context, title: ""),
                child: BlocBuilder<MissionDetailBloc, MissionDetailState>(
                  buildWhen: (previous, current) => previous.isLoading != current.isLoading,
                  builder: (context, state) {
                    return Skeleton(
                      isLoading: state.isLoading,
                      skeleton: const MissionDetailSkeleton(),
                      child: () {
                        return NormalMission(
                          state.entity,
                          onExchangeClick: () {
                            router.pop(context);
                            _bloc.add(MissionDetailExchange());
                          },
                        );
                      }(),
                    );
                  },
                ),
              );
            },
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _controller,
              shouldLoop: true,
              blastDirectionality: BlastDirectionality.explosive,
              colors: const [
                ColorName.primary,
                ColorName.grey100,
                ColorName.secondary,
              ],
              gravity: 0.3,
              numberOfParticles: 30,
              minimumSize: const Size(25, 25),
              maximumSize: const Size(50, 50),
              createParticlePath: drawHeart,
              emissionFrequency: 0.001,
            ),
          ),
          BlocBuilder<MissionDetailBloc, MissionDetailState>(
            buildWhen: (previous, current) => previous.isRequestObtaining != current.isRequestObtaining,
            builder: (context, state) {
              return state.isRequestObtaining
                  ? Container(
                      color: Colors.black.withOpacity(0.5),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : const SizedBox.shrink();
            },
          )
        ],
      ),
    );
  }

  Path drawHeart(Size size) {
    final width = size.width;
    final height = size.height;

    final offsetX = width / 2; // X축 중심점
    final offsetY = height * 3 / 5; // Y축 중심점 조정
    final scale = min(width, height) / 4; // 하트의 크기를 조절하는 스케일 값

    final path = Path()
      ..moveTo(offsetX, offsetY) // 시작점
      ..cubicTo(
        offsetX + (1.5 * scale),
        offsetY - (2.5 * scale),
        offsetX + (3 * scale),
        offsetY + (1 * scale),
        offsetX,
        offsetY + (2.5 * scale),
      )
      ..moveTo(offsetX, offsetY) // 시작점
      ..cubicTo(
        offsetX - (1.5 * scale),
        offsetY - (2.5 * scale),
        offsetX - (3 * scale),
        offsetY + (1 * scale),
        offsetX,
        offsetY + (2.5 * scale),
      )
      ..close();

    return path;
  }
}
