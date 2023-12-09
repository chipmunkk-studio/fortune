import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/core/util/textstyle.dart';
import 'package:fortune/core/widgets/fortune_scaffold.dart';
import 'package:fortune/di.dart';
import 'package:fortune/presentation/termsdetail/bloc/terms_detail.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

class TermsDetailPage extends StatelessWidget {
  final int index;

  const TermsDetailPage(
    this.index, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<TermsDetailBloc>()..add(TermsDetailInit(index)),
      child: FortuneScaffold(
        appBar: FortuneCustomAppBar.leadingAppBar(context, title: FortuneTr.fortuneTermsOfUse),
        child: const _TermsDetailPage(),
      ),
    );
  }
}

class _TermsDetailPage extends StatefulWidget {
  const _TermsDetailPage({Key? key}) : super(key: key);

  @override
  State<_TermsDetailPage> createState() => _TermsDetailPageState();
}

class _TermsDetailPageState extends State<_TermsDetailPage> {
  late TermsDetailBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<TermsDetailBloc>(context);
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSideEffectListener<TermsDetailBloc, TermsDetailSideEffect>(
      listener: (context, sideEffect) async {
        if (sideEffect is TermsDetailError) {
          dialogService.showAppErrorDialog(context, sideEffect.error);
        }
      },
      child: BlocBuilder<TermsDetailBloc, TermsDetailState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  state.terms.content,
                  style: FortuneTextStyle.body2Regular(),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
