import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortune/core/navigation/fortune_app_router.dart';
import 'package:fortune/core/widgets/fortune_scaffold.dart';
import 'package:fortune/di.dart';
import 'package:fortune/presentation-v2/missiondetail/mission_detail_param.dart';
import 'package:fortune/presentation-v2/missions/component/mission_card_list.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';
import 'package:skeletons/skeletons.dart';

import 'bloc/missions.dart';
import 'component/missions_skeleton.dart';

class MissionsPage extends StatelessWidget {
  const MissionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<MissionsBloc>()..add(MissionsInit()),
      child: const _MissionsPage(),
    );
  }
}

class _MissionsPage extends StatefulWidget {
  const _MissionsPage();

  @override
  State<_MissionsPage> createState() => _MissionsPageState();
}

class _MissionsPageState extends State<_MissionsPage> {
  final _router = serviceLocator<FortuneAppRouter>().router;
  late MissionsBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<MissionsBloc>(context);
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSideEffectListener<MissionsBloc, MissionsSideEffect>(
      listener: (context, sideEffect) async {
        if (sideEffect is MissionsError) {
          dialogService2.showAppErrorDialog(context, sideEffect.error);
        }
      },
      child: FortuneScaffold(
        appBar: FortuneCustomAppBar.leadingAppBar(context),
        child: BlocBuilder<MissionsBloc, MissionsState>(
          buildWhen: (previous, current) => previous.isLoading != current.isLoading,
          builder: (context, state) {
            return Skeleton(
              isLoading: state.isLoading,
              skeleton: const MissionsSkeleton(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: MissionCardList(
                      missions: state.missions,
                      onItemClick: (mission) {
                        _router.navigateTo(
                          context,
                          AppRoutes.missionDetailRoute,
                          routeSettings: RouteSettings(
                            arguments: MissionDetailParam(
                              missionId: mission.id,
                              ts: state.timestamps.mission,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
