import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foresh_flutter/core/widgets/fortune_scaffold.dart';
import 'package:foresh_flutter/di.dart';
import 'package:foresh_flutter/presentation/alarmfeed/bloc/alarm_feed.dart';
import 'package:foresh_flutter/presentation/fortune_router.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

class AlarmFeedPage extends StatelessWidget {
  const AlarmFeedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<AlarmFeedBloc>()..add(AlarmFeedInit()),
      child: FortuneScaffold(
        appBar: FortuneCustomAppBar.leadingAppBar(context, title: ''),
        child: const _AlarmFeedPage(),
      ),
    );
  }
}

class _AlarmFeedPage extends StatefulWidget {
  const _AlarmFeedPage({Key? key}) : super(key: key);

  @override
  State<_AlarmFeedPage> createState() => _AlarmFeedPageState();
}

class _AlarmFeedPageState extends State<_AlarmFeedPage> {

  final _router = serviceLocator<FortuneRouter>().router;
  late AlarmFeedBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<AlarmFeedBloc>(context);
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSideEffectListener<AlarmFeedBloc, AlarmFeedSideEffect>(
      listener: (context, sideEffect) async {
        if (sideEffect is AlarmFeedError) {
          dialogService.showErrorDialog(context, sideEffect.error);
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [],
      ),
    );
  }
}