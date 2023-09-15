import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foresh_flutter/core/util/date.dart';
import 'package:foresh_flutter/core/widgets/fortune_scaffold.dart';
import 'package:foresh_flutter/di.dart';
import 'package:foresh_flutter/presentation/fortune_router.dart';
import 'package:foresh_flutter/presentation/support/component/support_skeleton.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';
import 'package:skeletons/skeletons.dart';

import '../component/support_card.dart';
import 'bloc/notices.dart';

class NoticesPage extends StatelessWidget {
  const NoticesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<NoticesBloc>()..add(NoticesInit()),
      child: FortuneScaffold(
        appBar: FortuneCustomAppBar.leadingAppBar(context, title: "자주 묻는 질문"),
        child: const _NoticesPage(),
      ),
    );
  }
}

class _NoticesPage extends StatefulWidget {
  const _NoticesPage({Key? key}) : super(key: key);

  @override
  State<_NoticesPage> createState() => _NoticesPageState();
}

class _NoticesPageState extends State<_NoticesPage> {
  late final NoticesBloc _bloc;
  final router = serviceLocator<FortuneRouter>().router;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<NoticesBloc>(context);
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSideEffectListener<NoticesBloc, NoticesSideEffect>(
      listener: (context, sideEffect) {
        if (sideEffect is NoticesError) {
          dialogService.showErrorDialog(context, sideEffect.error);
        }
      },
      child: BlocBuilder<NoticesBloc, NoticesState>(
        builder: (context, state) {
          return Skeleton(
            isLoading: state.isLoading,
            skeleton: const SupportSkeleton(),
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemCount: state.items.length,
              separatorBuilder: (context, index) => const SizedBox(height: 20),
              itemBuilder: (context, index) {
                final item = state.items[index];
                return SupportCard(
                  title: item.title,
                  content: item.content,
                  date: FortuneDateExtension.formattedDate(item.createdAt),
                );
              },
            ),
          );
        },
      ),
    );
  }
}