import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foresh_flutter/core/gen/colors.gen.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';
import 'package:foresh_flutter/di.dart';
import 'package:foresh_flutter/presentation/fortune_router.dart';
import 'package:foresh_flutter/presentation/inventory/bloc/inventory.dart';
import 'package:foresh_flutter/presentation/inventory/component/profile.dart';
import 'package:skeletons/skeletons.dart';

import 'component/stamp_exchange.dart';

class InventoryBottomPage extends StatelessWidget {
  const InventoryBottomPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<InventoryBloc>()..add(InventoryInit()),
      child: const _InventoryBottomPage(),
    );
  }
}

class _InventoryBottomPage extends StatefulWidget {
  const _InventoryBottomPage();

  @override
  State<_InventoryBottomPage> createState() => _InventoryBottomPageState();
}

class _InventoryBottomPageState extends State<_InventoryBottomPage> {
  final router = serviceLocator<FortuneRouter>().router;

  late final InventoryBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<InventoryBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InventoryBloc, InventoryState>(
      buildWhen: (previous, current) => previous.isLoading != current.isLoading,
      builder: (context, state) {
        return Skeleton(
          isLoading: state.isLoading,
          skeleton: Container(),
          child: Column(
            children: [
              BlocBuilder<InventoryBloc, InventoryState>(
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
              BlocBuilder<InventoryBloc, InventoryState>(
                buildWhen: (previous, current) => previous.currentTab != current.currentTab,
                builder: (context, state) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: CustomSlidingSegmentedControl<int>(
                      initialValue: 2,
                      height: 48,
                      children: {
                        1: Text('상시 미션', style: () {
                          if (state.currentTab == InventoryTabMission.ordinary) {
                            return FortuneTextStyle.body1SemiBold(fontColor: ColorName.active);
                          } else {
                            return FortuneTextStyle.body1Medium(fontColor: ColorName.deActive);
                          }
                        }()),
                        2: Text('라운드 미션', style: () {
                          if (state.currentTab == InventoryTabMission.round) {
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
                      onValueChanged: (v) => _bloc.add(InventoryTabSelected(v)),
                    ),
                  );
                },
              ),
              SizedBox(height: 33.h),
              StampExchange(
                onStampExchangeClick: () => _navigateToExchangePage(context),
              ),
              SizedBox(height: 12.h),
              DefaultTabController(
                length: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ButtonsTabBar(
                      physics: const BouncingScrollPhysics(),
                      backgroundColor: Colors.red,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                      unselectedBackgroundColor: Colors.grey[300],
                      labelSpacing: 8,
                      radius: 24.r,
                  buttonMargin:EdgeInsets.only(left: 20),
                      unselectedLabelStyle: TextStyle(color: Colors.black),
                      labelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      tabs: [
                        Tab(
                          icon: Icon(Icons.directions_car),
                          text: "아이스크림",
                        ),
                        Tab(
                          icon: Icon(Icons.directions_transit),
                          text: "아메리카노",
                        ),
                        Tab(icon: Icon(Icons.directions_bike)),
                        Tab(icon: Icon(Icons.directions_car)),
                        Tab(icon: Icon(Icons.directions_transit)),
                        Tab(icon: Icon(Icons.directions_bike)),
                      ],
                    ),
                    Container(
                      height: 300,
                      color: Colors.white,
                      child: TabBarView(
                        physics: const BouncingScrollPhysics(),
                        children: <Widget>[
                          Center(
                            child: Icon(Icons.directions_car),
                          ),
                          Center(
                            child: Icon(Icons.directions_transit),
                          ),
                          Center(
                            child: Icon(Icons.directions_bike),
                          ),
                          Center(
                            child: Icon(Icons.directions_car),
                          ),
                          Center(
                            child: Icon(Icons.directions_transit),
                          ),
                          Center(
                            child: Icon(Icons.directions_bike),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  _navigateToExchangePage(BuildContext context) {
    router.navigateTo(
      context,
      Routes.rewardListRoute,
    );
  }
}
