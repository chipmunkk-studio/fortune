import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foresh_flutter/core/gen/colors.gen.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';
import 'package:foresh_flutter/data/supabase/service_ext.dart';
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text('수행 가능한 미션', style: FortuneTextStyle.subTitle1SemiBold()),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    '미션을 완료하시면 리워드를 드려요!',
                    style: FortuneTextStyle.body2Regular(fontColor: ColorName.deActiveDark),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    height: 420,
                    child: BlocBuilder<MissionsBloc, MissionsState>(
                      buildWhen: (previous, current) => previous.missions != current.missions,
                      builder: (context, state) {
                        return MissionCardList(
                          missions: state.missions,
                          onItemClick: (entity) async {
                            await router.navigateTo(
                              context,
                              Routes.missionDetailNormalRoute,
                              routeSettings: RouteSettings(
                                arguments: entity,
                              ),
                            );
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
