import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortune/core/navigation/fortune_app_router.dart';
import 'package:fortune/core/util/mixpanel.dart';
import 'package:fortune/data/supabase/service_ext.dart';
import 'package:fortune/di.dart';
import 'package:fortune/domain/supabase/entity/ingredient_entity.dart';
import 'package:fortune/presentation/giftbox/giftbox_action_response.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'bloc/giftbox_action.dart';
import 'component/customer_ad_view.dart';
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

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<GiftboxActionBloc>(context);
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
        } else if (sideEffect is GiftboxProcessObtainAction) {
          _router.pop(context, GiftboxActionResponse(ingredient: sideEffect.ingredient));
        }
      },
      child: BlocBuilder<GiftboxActionBloc, GiftboxActionState>(
        buildWhen: (previous, current) =>
            previous.isLoading != current.isLoading || previous.isReadyToAd != current.isReadyToAd,
        builder: (context, state) {
          final isReadyToAd = state.isReadyToAd;
          return isReadyToAd
              ? CustomerAdView(
                  onPressed: () => _bloc.add(GiftboxActionCloseAd()),
                )
              : _buildGiftboxView(
                  state.entity.ingredient,
                  randomScratchersItems: state.randomScratchersItems,
                  randomScratcherSelected: state.randomScratcherSelected,
                );
        },
      ),
    );
  }

  _buildGiftboxView(
    IngredientEntity entity, {
    randomScratchersItems,
    randomScratcherSelected,
  }) {
    switch (entity.type) {
      case IngredientType.randomScratchSingle:
        return GiftboxScratchSingleView(
          randomNormalIngredients: randomScratchersItems,
          randomNormalSelected: randomScratcherSelected,
          onReceive: (selected) {
            _mixpanelTracker.trackEvent("기프티_싱글박스_오픈", properties: {
              'ingredient': _bloc.state.randomScratcherSelected.ingredient.exposureName,
              'type': _bloc.state.entity.giftType.name,
            });
            _bloc.add(GiftboxActionObtainSuccess(selected.ingredient));
          },
        );
      case IngredientType.randomScratchMulti:
        return GiftboxScratchMultiView(
          randomNormalIngredients: randomScratchersItems,
          randomNormalSelected: randomScratcherSelected,
          onReceive: (selected) {
            _mixpanelTracker.trackEvent("기프티_멀티박스_오픈", properties: {
              'ingredient': _bloc.state.randomScratcherSelected.ingredient.exposureName,
              'type': _bloc.state.entity.giftType.name,
            });
            _bloc.add(GiftboxActionObtainSuccess(selected.ingredient));
          },
        );
      default:
        return const DefaultBackgroundView();
    }
  }
}
