import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortune/di.dart';
import 'package:fortune/fortune_app_router.dart';
import 'package:fortune/presentation/main/bloc/main.dart';
import 'package:fortune/presentation/missions/component/mission_card_list.dart';
import 'package:fortune/presentation/missions/component/missions_skeleton.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';
import 'package:skeletons/skeletons.dart';

import 'bloc/missions.dart';

class MissionsBottomContents extends StatelessWidget {
  final MainBloc mainBloc;

  const MissionsBottomContents(this.mainBloc, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<MissionsBloc>()..add(MissionsBottomInit()),
      child: _MissionsBottomContents(mainBloc),
    );
  }
}

class _MissionsBottomContents extends StatefulWidget {
  final MainBloc mainBloc;

  const _MissionsBottomContents(this.mainBloc);

  @override
  State<_MissionsBottomContents> createState() => _MissionsBottomContentsState();
}

class _MissionsBottomContentsState extends State<_MissionsBottomContents> {
  final _router = serviceLocator<FortuneAppRouter>().router;

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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: BlocBuilder<MissionsBloc, MissionsState>(
                buildWhen: (previous, current) => previous.missions != current.missions,
                builder: (context, state) {
                  return MissionCardList(
                    missions: state.missions,
                    onItemClick: (entity) async {
                      await _router.navigateTo(
                        context,
                        Routes.missionDetailNormalRoute,
                        routeSettings: RouteSettings(
                          arguments: entity,
                        ),
                      );
                      _bloc.add(MissionsBottomInit());
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
