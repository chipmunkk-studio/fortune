import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foresh_flutter/core/error/fortune_error_dialog.dart';
import 'package:foresh_flutter/core/gen/colors.gen.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';
import 'package:foresh_flutter/di.dart';
import 'package:foresh_flutter/presentation/fortune_router.dart';
import 'package:foresh_flutter/presentation/missions/component/mission_card_list.dart';
import 'package:foresh_flutter/presentation/missions/component/missions_skeleton.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';
import 'package:skeletons/skeletons.dart';

import 'bloc/missions.dart';
import 'component/profile.dart';

class MissionsBottomPage extends StatelessWidget {
  const MissionsBottomPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<MissionsBloc>()..add(MissionsInit()),
      child: const _MissionsBottomPage(),
    );
  }
}

class _MissionsBottomPage extends StatefulWidget {
  const _MissionsBottomPage();

  @override
  State<_MissionsBottomPage> createState() => _MissionsBottomPageState();
}

class _MissionsBottomPageState extends State<_MissionsBottomPage> {
  final router = serviceLocator<FortuneRouter>().router;

  late final MissionsBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<MissionsBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocSideEffectListener<MissionsBloc, MissionsSideEffect>(
      listener: (BuildContext context, MissionsSideEffect sideEffect) {
        if (sideEffect is MissionsError) {
          context.handleError(sideEffect.error);
        }
      },
      child: BlocBuilder<MissionsBloc, MissionsState>(
        buildWhen: (previous, current) => previous.isLoading != current.isLoading,
        builder: (context, state) {
          return Skeleton(
            isLoading: state.isLoading,
            skeleton: const MissionsSkeleton(),
            child: Column(
              children: [
                BlocBuilder<MissionsBloc, MissionsState>(
                  buildWhen: (previous, current) =>
                      previous.nickname != current.nickname || previous.profileImage != current.profileImage,
                  builder: (context, state) {
                    return Profile(
                      profile: state.profileImage,
                      nickname: state.nickname,
                      onNicknameClick: () => router.navigateTo(context, Routes.myPageRoute),
                      onGradeClick: () => router.navigateTo(context, Routes.gradeGuideRoute),
                    );
                  },
                ),
                const SizedBox(height: 33),
                BlocBuilder<MissionsBloc, MissionsState>(
                  buildWhen: (previous, current) => previous.currentTab != current.currentTab,
                  builder: (context, state) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: CustomSlidingSegmentedControl<int>(
                        initialValue: 2,
                        height: 48,
                        children: {
                          1: Text('상시 미션', style: () {
                            if (state.currentTab == TabMission.ordinary) {
                              return FortuneTextStyle.body1SemiBold(fontColor: ColorName.active);
                            } else {
                              return FortuneTextStyle.body1Medium(fontColor: ColorName.deActive);
                            }
                          }()),
                          2: Text('라운드 미션', style: () {
                            if (state.currentTab == TabMission.round) {
                              return FortuneTextStyle.body1SemiBold(fontColor: ColorName.active);
                            } else {
                              return FortuneTextStyle.body1Medium(fontColor: ColorName.deActive);
                            }
                          }()),
                        },
                        isStretch: true,
                        decoration: BoxDecoration(
                          color: ColorName.deActiveDark,
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        thumbDecoration: BoxDecoration(
                          color: ColorName.background,
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.easeInToLinear,
                        onValueChanged: (v) => _bloc.add(MissionsTabSelected(v)),
                      ),
                    );
                  },
                ),
                SizedBox(height: 33.h),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    height: 320,
                    child: BlocBuilder<MissionsBloc, MissionsState>(
                      buildWhen: (previous, current) => previous.missions != current.missions,
                      builder: (context, state) {
                        return MissionCardList(
                          missions: state.missions,
                          onItemClick: (item) async {
                            final exchangeStatus = await router.navigateTo(
                              context,
                              Routes.missionDetailRoute,
                              routeSettings: RouteSettings(
                                arguments: item,
                              ),
                            );
                            _bloc.add(MissionsInit());
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
