import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/core/util/date.dart';
import 'package:fortune/core/widgets/fortune_scaffold.dart';
import 'package:fortune/di.dart';
import 'package:fortune/fortune_router.dart';
import 'package:fortune/presentation/support/component/support_skeleton.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';
import 'package:skeletons/skeletons.dart';

import '../component/support_card.dart';
import 'bloc/privacy_policy.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<PrivacyPolicyBloc>()..add(PrivacyPolicyInit()),
      child: FortuneScaffold(
        appBar: FortuneCustomAppBar.leadingAppBar(
          context,
          title: FortuneTr.msgPrivacyPolicy,
        ),
        child: const _PrivacyPolicyPage(),
      ),
    );
  }
}

class _PrivacyPolicyPage extends StatefulWidget {
  const _PrivacyPolicyPage({Key? key}) : super(key: key);

  @override
  State<_PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<_PrivacyPolicyPage> {
  late final PrivacyPolicyBloc _bloc;
  final router = serviceLocator<FortuneRouter>().router;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<PrivacyPolicyBloc>(context);
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSideEffectListener<PrivacyPolicyBloc, PrivacyPolicySideEffect>(
      listener: (context, sideEffect) {
        if (sideEffect is PrivacyPolicyError) {
          dialogService.showErrorDialog(context, sideEffect.error);
        }
      },
      child: BlocBuilder<PrivacyPolicyBloc, PrivacyPolicyState>(
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
