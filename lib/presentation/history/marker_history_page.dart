import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';
import 'package:foresh_flutter/core/widgets/fortune_scaffold.dart';
import 'package:foresh_flutter/di.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'bloc/marker_history.dart';

class MarkerHistoryPage extends StatelessWidget {
  const MarkerHistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<MarkerHistoryBloc>()..add(MarkerHistoryInit()),
      child: const _MarkerHistoryPage(),
    );
  }
}

class _MarkerHistoryPage extends StatefulWidget {
  const _MarkerHistoryPage({Key? key}) : super(key: key);

  @override
  State<_MarkerHistoryPage> createState() => _MarkerHistoryPageState();
}

class _MarkerHistoryPageState extends State<_MarkerHistoryPage> {
  static const offsetVisibleThreshold = 50.0;
  late MarkerHistoryBloc _bloc;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<MarkerHistoryBloc>(context);
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _bloc.close();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSideEffectListener<MarkerHistoryBloc, MarkerHistorySideEffect>(
      listener: (context, sideEffect) {
        if (sideEffect is MarkerHistoryNextPage) {}
      },
      child: FortuneScaffold(
        appBar: FortuneCustomAppBar.leadingAppBar(
          context,
          title: "포춘스팟",
        ),
        child: BlocBuilder<MarkerHistoryBloc, MarkerHistoryState>(
          builder: (context, state) {
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              controller: _scrollController,
              itemBuilder: (context, index) {
                if (state.histories.isNotEmpty) {
                  final item = state.histories[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(
                        item.nickname,
                        style: FortuneTextStyle.body1SemiBold(),
                      ),
                      leading: const CircleAvatar(
                        backgroundColor: Colors.redAccent,
                        child: Icon(
                          Icons.mood_bad,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                }
                return const CircularProgressIndicator();
              },
              itemCount: state.histories.length,
            );
          },
        ),
      ),
    );
  }

  void _onScroll() {
    final max = _scrollController.position.maxScrollExtent;
    final offset = _scrollController.offset;

    if (offset + offsetVisibleThreshold >= max) {
      _bloc.add(MarkerHistoryNextPage());
    }
  }
}
