import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foresh_flutter/di.dart';
import 'package:foresh_flutter/presentation/fortune_router.dart';
import 'package:foresh_flutter/presentation/main/bloc/main.dart';
import 'package:foresh_flutter/presentation/missions/component/mission_card_list.dart';
import 'package:foresh_flutter/presentation/missions/component/missions_skeleton.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';
import 'package:skeletons/skeletons.dart';

import 'bloc/missions.dart';

class MissionsBottomPage extends StatelessWidget {
  final MainBloc mainBloc;

  const MissionsBottomPage(this.mainBloc, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<MissionsBloc>()..add(MissionsInit()),
      child: _MissionsBottomPage(mainBloc),
    );
  }
}

class _MissionsBottomPage extends StatefulWidget {
  final MainBloc mainBloc;

  const _MissionsBottomPage(this.mainBloc);

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
                          onItemClick: (missionId) async {
                            final exchangeStatus = await router.navigateTo(
                              context,
                              Routes.missionDetailRoute,
                              routeSettings: RouteSettings(
                                arguments: missionId,
                              ),
                            );
                            serviceLocator<MainBloc>().add(Main());
                            widget.mainBloc.add(Main());
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
