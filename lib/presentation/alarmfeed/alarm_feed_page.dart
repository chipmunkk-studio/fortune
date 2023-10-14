import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fortune/core/gen/assets.gen.dart';
import 'package:fortune/core/gen/colors.gen.dart';
import 'package:fortune/core/util/date.dart';
import 'package:fortune/core/util/textstyle.dart';
import 'package:fortune/core/widgets/fortune_scaffold.dart';
import 'package:fortune/di.dart';
import 'package:fortune/presentation/alarmfeed/bloc/alarm_feed.dart';
import 'package:fortune/presentation/alarmfeed/component/alarm_feed_skeleton.dart';
import 'package:fortune/core/navigation/fortune_app_router.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';
import 'package:skeletons/skeletons.dart';

class AlarmFeedPage extends StatelessWidget {
  const AlarmFeedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<AlarmFeedBloc>()..add(AlarmRewardInit()),
      child: FortuneScaffold(
        appBar: FortuneCustomAppBar.leadingAppBar(context, title: '알림'),
        child: const _AlarmFeedPage(),
      ),
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
  late AlarmFeedBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<AlarmFeedBloc>(context);
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSideEffectListener<AlarmFeedBloc, AlarmFeedSideEffect>(
      listener: (context, sideEffect) async {
        if (sideEffect is AlarmFeedError) {
          dialogService.showErrorDialog(context, sideEffect.error);
        }
      },
      child: BlocBuilder<AlarmFeedBloc, AlarmFeedState>(
        buildWhen: (previous, current) => previous.feeds != current.feeds,
        builder: (context, state) {
          return Skeleton(
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
                            onTap: () => _router.navigateTo(
                              context,
                              AppRoutes.alarmRewardRoute,
                              routeSettings: RouteSettings(
                                arguments: item.reward.id,
                              ),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: ColorName.grey800,
                                borderRadius: BorderRadius.circular(
                                  20.r,
                                ),
                              ),
                              child: Column(
                                children: [
                                  const SizedBox(height: 20),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(width: 20),
                                      Assets.icons.icMegaphone.svg(
                                        width: 20,
                                        height: 20,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.headings,
                                              style: FortuneTextStyle.body2Semibold(),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              item.content,
                                              style: FortuneTextStyle.body3Light(color: ColorName.grey200),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        FortuneDateExtension.convertTimeAgo(item.createdAt),
                                        style: FortuneTextStyle.body3Light(color: ColorName.grey200),
                                      ),
                                      const SizedBox(width: 20),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  )
                : Center(
                    child: Text(
                      "알림이 없습니다",
                      style: FortuneTextStyle.subTitle1Medium(),
                    ),
                  ),
          );
        },
      ),
    );
  }
}
