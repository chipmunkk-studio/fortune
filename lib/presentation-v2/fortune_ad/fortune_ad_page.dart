import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortune/core/navigation/fortune_app_router.dart';
import 'package:fortune/di.dart';
import 'package:fortune/presentation-v2/admanager/fortune_ad.dart';
import 'package:fortune/presentation-v2/fortune_ad/bloc/fortune_ad.dart';
import 'package:fortune/presentation-v2/fortune_ad/component/customer_ad_view.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'component/ad_loading_view.dart';
import 'fortune_ad_complete_return.dart';
import 'fortune_ad_param.dart';

class FortuneAdPage extends StatelessWidget {
  final FortuneAdParam param;

  const FortuneAdPage(
    this.param, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<FortuneAdBloc>()..add(FortuneAdInit(param)),
      child: const _FortuneAdPage(),
    );
  }
}

class _FortuneAdPage extends StatefulWidget {
  const _FortuneAdPage();

  @override
  State<_FortuneAdPage> createState() => _FortuneAdPageState();
}

class _FortuneAdPageState extends State<_FortuneAdPage> {
  final _router = serviceLocator<FortuneAppRouter>().router;
  late FortuneAdBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<FortuneAdBloc>(context);
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSideEffectListener<FortuneAdBloc, FortuneAdSideEffect>(
      listener: (context, sideEffect) {
        if (sideEffect is FortuneAdError) {
          dialogService2.showAppErrorDialog(context, sideEffect.error);
        } else if (sideEffect is FortuneShowAdmob) {
          sideEffect.ad.rewardedAd?.show(
            onUserEarnedReward: (ad, rewardItem) {
              _bloc.add(FortuneAdShowComplete());
            },
          );
        } else if (sideEffect is FortuneAdShowCompleteReturn) {
          _router.pop(
            context,
            FortuneAdCompleteReturn(
              user: sideEffect.user,
            ),
          );
        }
      },
      child: BlocBuilder<FortuneAdBloc, FortuneAdViewState>(
        builder: (BuildContext context, FortuneAdViewState state) {
          if (state.isAdRequestError) {
            return CustomerAdView(
              onPressed: () {
                _bloc.add(FortuneAdShowComplete());
              },
            );
          } else {
            final adState = state.adState;
            if (adState is FortuneExternalAdStateEntity) {
              // 외부 광고 일 경우
              return Container();
            } else if (adState is FortuneCustomAdStateEntity) {
              // 내부 광고 일 경우.
              return Container();
            } else {
              return const AdLoadingView();
            }
          }
        },
      ),
    );
  }
}
