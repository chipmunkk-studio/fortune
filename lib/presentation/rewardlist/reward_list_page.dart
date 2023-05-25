import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foresh_flutter/core/gen/colors.gen.dart';
import 'package:foresh_flutter/core/widgets/fortune_scaffold.dart';
import 'package:foresh_flutter/di.dart';
import 'package:foresh_flutter/presentation/fortune_router.dart';
import 'package:foresh_flutter/presentation/rewardlist/bloc/reward_list.dart';
import 'package:skeletons/skeletons.dart';

import 'component/my_stamps.dart';
import 'component/my_stamps_filter.dart';
import 'component/product_list.dart';
import 'component/skeleton.dart';

class RewardListPage extends StatelessWidget {
  const RewardListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<RewardListBloc>()..add(RewardListInit()),
      child: FortuneScaffold(
        appBar: FortuneCustomAppBar.leadingAppBar(context, title: "포춘 교환소"),
        child: _RewardListPage(),
      ),
    );
  }
}

class _RewardListPage extends StatefulWidget {
  @override
  _RewardListPageState createState() => _RewardListPageState();
}

class _RewardListPageState extends State<_RewardListPage> {
  final router = serviceLocator<FortuneRouter>().router;

  late final RewardListBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<RewardListBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RewardListBloc, RewardListState>(
      buildWhen: (previous, current) => previous.isLoading != current.isLoading,
      builder: (context, state) {
        return Skeleton(
          isLoading: state.isLoading,
          skeleton: const SkeletonRewardList(),
          child: Column(
            children: [
              BlocBuilder<RewardListBloc, RewardListState>(
                buildWhen: (previous, current) => previous.markers != current.markers,
                builder: (context, state) {
                  return MyStamps(
                    totalMarkerCount: state.totalMarkerCount,
                    markers: state.markers,
                  );
                },
              ),
              const SizedBox(height: 32),
              BlocBuilder<RewardListBloc, RewardListState>(
                buildWhen: (previous, current) => previous.isChangeableChecked != current.isChangeableChecked,
                builder: (context, state) {
                  return MyStampsFilter(
                    state.isChangeableChecked,
                    onCheck: (isChecked) => _bloc.add(RewardListChangeCheckStatus()),
                  );
                },
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Stack(
                  children: [
                    BlocBuilder<RewardListBloc, RewardListState>(
                      buildWhen: (previous, current) => previous.rewards != current.rewards,
                      builder: (context, state) {
                        return ProductList(
                          rewards: state.rewards,
                          onItemClick: (item) async {
                            final exchangeStatus = await router.navigateTo(
                              context,
                              Routes.rewardDetailRoute,
                              routeSettings: RouteSettings(
                                arguments: item,
                              ),
                            );
                            _bloc.add(RewardListInit());
                          },
                          onNextPage: () => _bloc.add(RewardListNextPage()),
                        );
                      },
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              ColorName.background.withOpacity(1.0),
                              ColorName.background.withOpacity(0.0),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
