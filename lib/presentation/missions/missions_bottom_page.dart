import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foresh_flutter/di.dart';
import 'package:foresh_flutter/presentation/fortune_router.dart';
import 'package:foresh_flutter/presentation/missions/component/mission_card_list.dart';
import 'package:foresh_flutter/presentation/missions/component/missions_skeleton.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';
import 'package:skeletons/skeletons.dart';

import 'bloc/missions.dart';

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
          dialogService.showErrorDialog(context, sideEffect.error);
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
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    height: 460,
                    child: BlocBuilder<MissionsBloc, MissionsState>(
                      buildWhen: (previous, current) => previous.missions != current.missions,
                      builder: (context, state) {
                        return MissionCardList(
                          missions: state.missions,
                          onItemClick: (item) async {
                            final exchangeStatus = await router.navigateTo(
                              context,
                              Routes.obtainHistoryRoute,
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
