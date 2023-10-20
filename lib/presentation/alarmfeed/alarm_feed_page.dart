import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:fortune/core/gen/colors.gen.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/core/navigation/fortune_app_router.dart';
import 'package:fortune/core/util/mixpanel.dart';
import 'package:fortune/core/util/textstyle.dart';
import 'package:fortune/core/widgets/fortune_cached_network_Image.dart';
import 'package:fortune/core/widgets/fortune_scaffold.dart';
import 'package:fortune/di.dart';
import 'package:fortune/presentation/alarmfeed/bloc/alarm_feed.dart';
import 'package:fortune/presentation/alarmfeed/component/alarm_feed_skeleton.dart';
import 'package:fortune/presentation/alarmfeed/component/item_alarm_feed.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';
import 'package:skeletons/skeletons.dart';

class AlarmFeedPage extends StatelessWidget {
  const AlarmFeedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<AlarmFeedBloc>()..add(AlarmRewardInit()),
      child: const _AlarmFeedPage(),
    );
  }
}

class _AlarmFeedPage extends StatefulWidget {
  const _AlarmFeedPage({Key? key}) : super(key: key);

  @override
  State<_AlarmFeedPage> createState() => _AlarmFeedPageState();
}

class _AlarmFeedPageState extends State<_AlarmFeedPage> {
  final _router = serviceLocator<FortuneAppRouter>().router;
  final ConfettiController _controller = ConfettiController(
    duration: const Duration(
      seconds: 2,
    ),
  );
  late AlarmFeedBloc _bloc;
  final MixpanelTracker tracker = serviceLocator<MixpanelTracker>();

  @override
  void initState() {
    super.initState();
    tracker.trackEvent('알림_랜딩');
    _bloc = BlocProvider.of<AlarmFeedBloc>(context);
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.close();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSideEffectListener<AlarmFeedBloc, AlarmFeedSideEffect>(
      listener: (context, sideEffect) async {
        if (sideEffect is AlarmFeedError) {
          dialogService.showErrorDialog(context, sideEffect.error);
        } else if (sideEffect is AlarmFeedReceiveConfetti) {
          _controller.play();
        } else if (sideEffect is AlarmFeedReceiveShowDialog) {
          final reward = sideEffect.entity.reward;
          dialogService.showFortuneDialog(
            context,
            dismissOnBackKeyPress: true,
            dismissOnTouchOutside: true,
            subTitle: FortuneTr.msgAcquiredMarker(reward.ingredients.exposureName),
            btnOkText: FortuneTr.confirm,
            btnOkPressed: () {},
            topContent: SizedBox.square(
              dimension: 84,
              child: ClipOval(
                child: FortuneCachedNetworkImage(
                  imageUrl: reward.ingredients.imageUrl,
                  placeholder: Container(),
                  errorWidget: const Icon(Icons.error_outline),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          );
        }
      },
      child: BlocBuilder<AlarmFeedBloc, AlarmFeedState>(
        buildWhen: (previous, current) => previous.feeds != current.feeds,
        builder: (context, state) {
          return Stack(
            children: [
              FortuneScaffold(
                appBar: FortuneCustomAppBar.leadingAppBar(context, title: '알림'),
                child: Skeleton(
                  skeleton: const AlarmFeedSkeleton(),
                  isLoading: state.isLoading,
                  child: state.feeds.isNotEmpty
                      ? Stack(
                          children: [
                            ListView.separated(
                              physics: const BouncingScrollPhysics(),
                              itemCount: state.feeds.length,
                              separatorBuilder: (context, index) => const SizedBox(height: 20),
                              itemBuilder: (context, index) {
                                final item = state.feeds[index];
                                return Bounceable(
                                  onTap: () => _bloc.add(AlarmRewardReceive(item)),
                                  child: ItemAlarmFeed(
                                    item,
                                    onReceive: (feed) => _bloc.add(AlarmRewardReceive(item)),
                                  ),
                                );
                              },
                            ),
                          ],
                        )
                      : Center(
                          child: Text(
                            FortuneTr.msgNoNotifications,
                            style: FortuneTextStyle.subTitle1Medium(),
                          ),
                        ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: _controller,
                  shouldLoop: false,
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
                  createParticlePath: _drawHeart,
                  emissionFrequency: 0.001,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Path _drawHeart(Size size) {
    final double width = size.width;
    final double height = size.height;

    final path = Path()
      ..moveTo(width * 0.5, height * 0.75) // 시작점: 하트의 아래쪽 끝
      // 왼쪽 반원 (왼쪽 상단)
      ..cubicTo(width * 0.2, height * 0.75, 0, height * 0.5, width * 0.5, height * 0.3)
      // 오른쪽 반원 (오른쪽 상단)
      ..cubicTo(width, height * 0.5, width * 0.8, height * 0.75, width * 0.5, height * 0.75)
      ..close();

    return path;
  }
}
