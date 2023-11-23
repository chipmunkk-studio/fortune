import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/core/navigation/fortune_app_router.dart';
import 'package:fortune/core/util/adhelper.dart';
import 'package:fortune/core/util/mixpanel.dart';
import 'package:fortune/core/util/textstyle.dart';
import 'package:fortune/core/widgets/fortune_scaffold.dart';
import 'package:fortune/data/supabase/service_ext.dart';
import 'package:fortune/di.dart';
import 'package:fortune/presentation/ingredientaction/bloc/ingredient_action.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';
import 'package:vungle/vungle.dart';

import 'ingredient_action_param.dart';
import 'ingredient_action_response.dart';

class IngredientActionPage extends StatelessWidget {
  final IngredientActionParam param;

  const IngredientActionPage(
    this.param, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<IngredientActionBloc>()..add(IngredientActionInit(param)),
      child: const _IngredientActionPage(),
    );
  }
}

class _IngredientActionPage extends StatefulWidget {
  const _IngredientActionPage();

  @override
  State<_IngredientActionPage> createState() => _IngredientActionPageState();
}

class _IngredientActionPageState extends State<_IngredientActionPage> {
  final _router = serviceLocator<FortuneAppRouter>().router;
  final MixpanelTracker _mixpanelTracker = serviceLocator<MixpanelTracker>();

  late IngredientActionBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<IngredientActionBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocSideEffectListener<IngredientActionBloc, IngredientActionSideEffect>(
      listener: (context, sideEffect) async {
        if (sideEffect is IngredientActionError) {
          dialogService.showAppErrorDialog(context, sideEffect.error);
        } else if (sideEffect is IngredientProcessAction) {
          _processAction(sideEffect);
        } else if (sideEffect is IngredientAdShowComplete) {
          _adShowComplete(sideEffect);
        }
      },
      child: BlocBuilder<IngredientActionBloc, IngredientActionState>(
        builder: (context, state) {
          return _buildProcessWidgetOnType(state.entity);
        },
      ),
    );
  }

  _buildProcessWidgetOnType(IngredientActionParam entity) {
    switch (entity.ingredient.type) {
      case IngredientType.coin:
        return FortuneScaffold(
          appBar: FortuneCustomAppBar.leadingAppBar(
            context,
            backgroundColor: Colors.black.withOpacity(0.5),
          ),
          backgroundColor: Colors.black.withOpacity(0.8),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 80.h),
              child: Text(
                FortuneTr.msgAdPlaying,
                style: FortuneTextStyle.body1Light(height: 1.3),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      default:
        return Container(color: Colors.black.withOpacity(0.5));
    }
  }

  void handleAdComplete(String eventType, IngredientActionParam param) {
    _mixpanelTracker.trackEvent(
      eventType,
      properties: param.user?.toJson(),
    );
    _bloc.add(IngredientActionShowAdCounting());
  }

  void showAdMobAd(IngredientActionParam param) {
    param.ad?.show(
      onUserEarnedReward: (_, reward) => handleAdComplete('광고 보기 완료 #1', param),
    );
  }

  void showAdIfNeeded(
    IngredientActionParam param,
    bool adMobStatus,
  ) async {
    if (param.ad == null && adMobStatus) {
      noAdsAction(param);
      return;
    }

    if (!adMobStatus) {
      try {
        if (await Vungle.isAdPlayable(VungleAdHelper.rewardedAdUnitId)) {
          Vungle.playAd(VungleAdHelper.rewardedAdUnitId);
          Vungle.onAdRewardedListener = (_) => handleAdComplete('광고 보기 완료 #2', param);
          Vungle.onAdLeftApplicationListener = (_) => Navigator.pop(context);
        } else {
          Vungle.loadAd(VungleAdHelper.rewardedAdUnitId);
          showAdMobAd(param);
        }
      } catch (e) {
        noAdsAction(param);
      }
    } else {
      showAdMobAd(param);
    }
  }

  void noAdsAction(IngredientActionParam param) {
    _mixpanelTracker.trackEvent(
      '광고 없음',
      properties: param.user?.toJson(),
    );
    _router.pop(
      context,
      IngredientActionResponse(
        ingredient: param.ingredient,
        result: false,
      ),
    );
  }

  _handleAdDisplay(IngredientProcessAction sideEffect) {
    if (!sideEffect.param.isShowAd) {
      _bloc.add(IngredientActionShowAdCounting());
      return;
    }

    try {
      showAdIfNeeded(
        sideEffect.param,
        sideEffect.adMobStatus,
      );
    } catch (e) {
      noAdsAction(sideEffect.param);
    }
  }

  _processAction(IngredientProcessAction sideEffect) {
    switch (sideEffect.param.ingredient.type) {
      case IngredientType.coin:
        _handleAdDisplay(sideEffect);
        break;
      default:
        _router.pop(
          context,
          IngredientActionResponse(
            ingredient: sideEffect.param.ingredient,
            result: true,
          ),
        );
    }
  }

  _adShowComplete(IngredientAdShowComplete sideEffect) {
    _router.pop(
      context,
      IngredientActionResponse(
        ingredient: sideEffect.ingredient,
        result: sideEffect.result,
      ),
    );
  }
}
