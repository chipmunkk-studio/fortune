import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foresh_flutter/core/widgets/dialog/default_dialog.dart';
import 'package:foresh_flutter/core/widgets/fortune_scaffold.dart';
import 'package:foresh_flutter/data/supabase/response/mission/mission_ext.dart';
import 'package:foresh_flutter/di.dart';
import 'package:foresh_flutter/domain/supabase/entity/mission/mission_view_entity.dart';
import 'package:foresh_flutter/presentation/fortune_router.dart';
import 'package:foresh_flutter/presentation/missiondetail/component/normal_mission.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'bloc/mission_detail.dart';

class MissionDetailPage extends StatelessWidget {
  const MissionDetailPage(
    this.mission, {
    Key? key,
  }) : super(key: key);

  final MissionViewEntity mission;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<MissionDetailBloc>()..add(MissionDetailInit(mission)),
      child: FortuneScaffold(
        padding: const EdgeInsets.all(0),
        appBar: FortuneCustomAppBar.leadingAppBar(context, title: ""),
        child: const _MissionDetailPage(),
      ),
    );
  }
}

class _MissionDetailPage extends StatefulWidget {
  const _MissionDetailPage({Key? key}) : super(key: key);

  @override
  State<_MissionDetailPage> createState() => _MissionDetailPageState();
}

class _MissionDetailPageState extends State<_MissionDetailPage> {
  late final MissionDetailBloc _bloc;
  final router = serviceLocator<FortuneRouter>().router;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<MissionDetailBloc>(context);
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSideEffectListener<MissionDetailBloc, MissionDetailSideEffect>(
      listener: (context, sideEffect) {
        if (sideEffect is MissionDetailClearSuccess) {
          context.showFortuneDialog(
            title: '교환신청 완료',
            subTitle: '축하해요!',
            btnOkText: '확인',
            btnOkPressed: () {
              router.pop(context, true);
            },
          );
        } else if (sideEffect is MissionDetailError) {
          dialogService.showErrorDialog(context, sideEffect.error);
        }
      },
      child: BlocBuilder<MissionDetailBloc, MissionDetailState>(
        builder: (context, state) {
          switch (state.entity.mission.missionType) {
            case MissionType.normal:
              return NormalMission(
                state,
                onExchangeClick: () {
                  router.pop(context);
                  _bloc.add(MissionDetailExchange());
                },
              );
            default:
              return Container();
          }
        },
      ),
    );
  }
}
