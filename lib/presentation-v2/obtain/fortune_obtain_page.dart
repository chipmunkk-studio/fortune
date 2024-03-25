import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortune/core/navigation/fortune_app_router.dart';
import 'package:fortune/di.dart';
import 'package:fortune/presentation-v2/obtain/bloc/fortune_obtain_event.dart';
import 'package:fortune/presentation-v2/obtain/fortune_obtain_param.dart';
import 'package:fortune/presentation-v2/obtain/fortune_obtain_success_return.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'bloc/fortune_obtain.dart';
import 'component/obtain_loading_view.dart';

class FortuneObtainPage extends StatelessWidget {
  final FortuneObtainParam param;

  const FortuneObtainPage(this.param, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<FortuneObtainBloc>()..add(FortuneObtainInit(param)),
      child: const _FortuneObtainPage(),
    );
  }
}

class _FortuneObtainPage extends StatefulWidget {
  const _FortuneObtainPage();

  @override
  State<_FortuneObtainPage> createState() => _FortuneObtainPageState();
}

class _FortuneObtainPageState extends State<_FortuneObtainPage> {
  final _router = serviceLocator<FortuneAppRouter>().router;
  late FortuneObtainBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<FortuneObtainBloc>(context);
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSideEffectListener<FortuneObtainBloc, FortuneObtainSideEffect>(
      listener: (context, sideEffect) {
        if (sideEffect is FortuneObtainError) {
          dialogService2.showAppErrorDialog(
            context,
            sideEffect.error,
            btnOkOnPress: () {
              _router.pop(context);
            },
          );
        } else if (sideEffect is FortuneCoinOrNormalObtainSuccess) {
          _router.pop(
            context,
            FortuneObtainSuccessReturn(
              markerObtainEntity: sideEffect.entity,
            ),
          );
        }
      },
      child: BlocBuilder<FortuneObtainBloc, FortuneObtainViewState>(
        builder: (BuildContext context, FortuneObtainViewState state) {
          if (state.isObtaining) {
            return ObtainLoadingView(state.processingMarker);
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
