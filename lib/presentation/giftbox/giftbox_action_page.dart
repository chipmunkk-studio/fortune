import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortune/core/navigation/fortune_app_router.dart';
import 'package:fortune/core/util/mixpanel.dart';
import 'package:fortune/data/supabase/service_ext.dart';
import 'package:fortune/di.dart';
import 'package:fortune/presentation/giftbox/giftbox_action_ad_manager.dart';
import 'package:fortune/presentation/giftbox/giftbox_action_response.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'bloc/giftbox_action.dart';
import 'component/ad_loading_view.dart';
import 'component/default_background_view.dart';
import 'giftbox_action_param.dart';
import 'giftbox_scratch_multi/giftbox_scratch_multi_view.dart';
import 'giftbox_scratch_single/giftbox_scratch_single_view.dart';

class GiftboxActionPage extends StatelessWidget {
  final GiftboxActionParam param;

  const GiftboxActionPage(
    this.param, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<GiftboxActionBloc>()..add(GiftboxActionInit(param)),
      child: const _GiftboxActionPage(),
    );
  }
}

class _GiftboxActionPage extends StatefulWidget {
  const _GiftboxActionPage();

  @override
  State<_GiftboxActionPage> createState() => _GiftboxActionPageState();
}

class _GiftboxActionPageState extends State<_GiftboxActionPage> {
  final _router = serviceLocator<FortuneAppRouter>().router;
  final MixpanelTracker _mixpanelTracker = serviceLocator<MixpanelTracker>();

  late GiftboxActionBloc _bloc;
  late GiftboxActionAdManager _adManager;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<GiftboxActionBloc>(context);
    _adManager = GiftboxActionAdManager(
      context,
      // 광고가 없을 경우.
      noAdAction: (param) {
        _mixpanelTracker.trackEvent('광고 없음', properties: param.user?.toJson());

        /// 광고 없어도 획득하게 해줌.
        _bloc.add(GiftboxActionShowAdCounting());
      },
      // 광고를 모두 봤을 경우.
      showAdSuccess: (param, type) {
        _mixpanelTracker.trackEvent('광고 보기 완료 : $type}', properties: param.user?.toJson());
        _bloc.add(GiftboxActionShowAdCounting());
      },
    );
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSideEffectListener<GiftboxActionBloc, GiftboxActionSideEffect>(
      listener: (context, sideEffect) async {
        if (sideEffect is GiftboxActionError) {
          dialogService.showAppErrorDialog(context, sideEffect.error);
        } else if (sideEffect is GiftboxProcessShowAdAction) {
          _adManager.handleAdDisplay(sideEffect);
        } else if (sideEffect is GiftboxProcessObtainAction) {
          _router.pop(context, GiftboxActionResponse(ingredient: sideEffect.ingredient));
        }
      },
      child: BlocBuilder<GiftboxActionBloc, GiftboxActionState>(
        buildWhen: (previous, current) => previous.isLoading != current.isLoading,
        builder: (context, state) {
          final currentGiftbox = state.entity.ingredient;
          switch (currentGiftbox.type) {
            case IngredientType.coin:
              return const AdLoadingView(true);
            case IngredientType.randomScratchSingle:
              return GiftboxScratchSingleView(
                randomNormalIngredients: state.randomScratchersItems,
                randomNormalSelected: state.randomScratcherSelected,
                onReceive: (selected) {
                  _bloc.add(GiftboxActionObtainSuccess(selected.ingredient));
                },
              );
            case IngredientType.randomScratchMulti:
              return GiftboxScratchMultiView(
                randomNormalIngredients: state.randomScratchersItems,
                randomNormalSelected: state.randomScratcherSelected,
                onReceive: (selected) {
                  _bloc.add(GiftboxActionObtainSuccess(selected.ingredient));
                },
              );
            default:
              return const DefaultBackgroundView();
          }
        },
      ),
    );
  }
}
