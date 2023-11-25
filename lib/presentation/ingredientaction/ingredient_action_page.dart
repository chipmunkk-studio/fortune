import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortune/core/navigation/fortune_app_router.dart';
import 'package:fortune/core/util/mixpanel.dart';
import 'package:fortune/data/supabase/service_ext.dart';
import 'package:fortune/di.dart';
import 'package:fortune/domain/supabase/entity/ingredient_entity.dart';
import 'package:fortune/presentation/ingredientaction/bloc/ingredient_action.dart';
import 'package:fortune/presentation/ingredientaction/ingredient_action_ad_manager.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'component/ad_loading_view.dart';
import 'component/default_background_view.dart';
import 'component/random_scratch_single/random_scratch_single_view.dart';
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
  late IngredientActionAdManager _adManager;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<IngredientActionBloc>(context);
    _adManager = IngredientActionAdManager(
      context,
      // 광고가 없을 경우.
      noAdAction: (param) {
        _mixpanelTracker.trackEvent('광고 없음', properties: param.user?.toJson());
        _router.pop(context, IngredientActionResponse(ingredient: param.ingredient, result: false));
      },
      // 광고를 모두 봤을 경우.
      showAdSuccess: (param, type) {
        _mixpanelTracker.trackEvent('광고 보기 완료 : $type}', properties: param.user?.toJson());
        _bloc.add(IngredientActionShowAdCounting());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocSideEffectListener<IngredientActionBloc, IngredientActionSideEffect>(
      listener: (context, sideEffect) async {
        if (sideEffect is IngredientActionError) {
          dialogService.showAppErrorDialog(context, sideEffect.error);
        } else if (sideEffect is IngredientProcessShowAdAction) {
          _adManager.handleAdDisplay(sideEffect);
        } else if (sideEffect is IngredientProcessObtainAction) {
          _returnActionComplete(
            returnIngredient: sideEffect.ingredient,
            result: sideEffect.result,
          );
        }
      },
      child: BlocBuilder<IngredientActionBloc, IngredientActionState>(
        buildWhen: (previous, current) => previous.isLoading != current.isLoading,
        builder: (context, state) {
          final currentIngredient = state.entity.ingredient;
          switch (currentIngredient.type) {
            case IngredientType.coin:
              return const AdLoadingView();
            case IngredientType.randomScratchSingle:
              return RandomScratchSingleView(
                randomNormalIngredients: state.randomScratchersItems,
                randomNormalSelected: state.randomScratcherSelected,
                onReceive: (selected) {
                  _returnActionComplete(
                    returnIngredient: selected.ingredient,
                    result: true,
                  );
                },
              );
            default:
              return const DefaultBackgroundView();
          }
        },
      ),
    );
  }

  _returnActionComplete({
    required IngredientEntity returnIngredient,
    required bool result,
  }) {
    _router.pop(
      context,
      IngredientActionResponse(
        ingredient: returnIngredient,
        result: result,
      ),
    );
  }
}
