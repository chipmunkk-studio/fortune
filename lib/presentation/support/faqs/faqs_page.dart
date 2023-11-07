import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/core/widgets/fortune_scaffold.dart';
import 'package:fortune/di.dart';
import 'package:fortune/core/navigation/fortune_app_router.dart';
import 'package:fortune/presentation/support/component/support_skeleton.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';
import 'package:skeletons/skeletons.dart';

import '../component/support_card.dart';
import 'bloc/faqs.dart';

class FaqPage extends StatelessWidget {
  const FaqPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<FaqsBloc>()..add(FaqInit()),
      child: FortuneScaffold(
        appBar: FortuneCustomAppBar.leadingAppBar(
          context,
          title: FortuneTr.faq,
        ),
        child: const _FaqPage(),
      ),
    );
  }
}

class _FaqPage extends StatefulWidget {
  const _FaqPage({Key? key}) : super(key: key);

  @override
  State<_FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<_FaqPage> {
  late final FaqsBloc _bloc;
  final router = serviceLocator<FortuneAppRouter>().router;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<FaqsBloc>(context);
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSideEffectListener<FaqsBloc, FaqsSideEffect>(
      listener: (context, sideEffect) {
        if (sideEffect is FaqError) {
          dialogService.showAppErrorDialog(context, sideEffect.error);
        }
      },
      child: BlocBuilder<FaqsBloc, FaqsState>(
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
                );
              },
            ),
          );
        },
      ),
    );
  }
}
