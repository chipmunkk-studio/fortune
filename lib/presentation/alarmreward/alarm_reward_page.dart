import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';
import 'package:foresh_flutter/core/widgets/fortune_scaffold.dart';
import 'package:foresh_flutter/di.dart';
import 'package:foresh_flutter/presentation/fortune_router.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'bloc/alarm_reward.dart';

class AlarmRewardPage extends StatelessWidget {
  final int rewardId;

  const AlarmRewardPage(this.rewardId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<AlarmRewardBloc>()..add(AlarmRewardInit(rewardId)),
      child: FortuneScaffold(
        appBar: FortuneCustomAppBar.leadingAppBar(context, title: '리워드 받기'),
        child: const _AlarmRewardPage(),
      ),
    );
  }
}

class _AlarmRewardPage extends StatefulWidget {
  const _AlarmRewardPage({Key? key}) : super(key: key);

  @override
  State<_AlarmRewardPage> createState() => _AlarmRewardPageState();
}

class _AlarmRewardPageState extends State<_AlarmRewardPage> {
  final _router = serviceLocator<FortuneRouter>().router;
  late AlarmRewardBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<AlarmRewardBloc>(context);
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSideEffectListener<AlarmRewardBloc, AlarmRewardSideEffect>(
      listener: (context, sideEffect) async {
        if (sideEffect is AlarmRewardError) {
          dialogService.showErrorDialog(context, sideEffect.error);
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("",style: FortuneTextStyle.body3Regular(),)
        ],
      ),
    );
  }
}
