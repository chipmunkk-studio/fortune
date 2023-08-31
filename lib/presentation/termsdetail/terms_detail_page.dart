import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foresh_flutter/core/util/textstyle.dart';
import 'package:foresh_flutter/core/widgets/fortune_scaffold.dart';
import 'package:foresh_flutter/di.dart';
import 'package:foresh_flutter/presentation/fortune_router.dart';
import 'package:foresh_flutter/presentation/termsdetail/bloc/terms_detail.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

class TermsDetailPage extends StatelessWidget {
  final int index;

  const TermsDetailPage(
    this.index, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<TermsDetailBloc>()..add(TermsDetailInit(index)),
      child: FortuneScaffold(
        appBar: FortuneCustomAppBar.leadingAppBar(context, title: '포춘 이용 약관'),
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
  final _router = serviceLocator<FortuneRouter>().router;
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
          dialogService.showErrorDialog(context, sideEffect.error);
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
                  style: FortuneTextStyle.body1Medium(),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
