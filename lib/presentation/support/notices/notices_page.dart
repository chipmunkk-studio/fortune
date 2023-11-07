import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/core/util/date.dart';
import 'package:fortune/core/widgets/fortune_scaffold.dart';
import 'package:fortune/di.dart';
import 'package:fortune/core/navigation/fortune_app_router.dart';
import 'package:fortune/presentation/support/component/support_skeleton.dart';
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
        appBar: FortuneCustomAppBar.leadingAppBar(
          context,
          title: FortuneTr.notice,
        ),
        child: const _NoticesPage(),
      ),
    );
  }
}

class _NoticesPage extends StatefulWidget {
  const _NoticesPage();

  @override
  State<_NoticesPage> createState() => _NoticesPageState();
}

class _NoticesPageState extends State<_NoticesPage> {
  late final NoticesBloc _bloc;
  final router = serviceLocator<FortuneAppRouter>().router;

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
          dialogService.showAppErrorDialog(context, sideEffect.error);
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
                  date: item.createdAt,
                  isPin: item.isPin,
                  isShowDate: true,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
