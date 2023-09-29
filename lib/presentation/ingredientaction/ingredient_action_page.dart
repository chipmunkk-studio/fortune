import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fortune/core/util/logger.dart';
import 'package:fortune/data/supabase/service/service_ext.dart';
import 'package:fortune/di.dart';
import 'package:fortune/domain/supabase/entity/ingredient_entity.dart';
import 'package:fortune/presentation/fortune_router.dart';
import 'package:fortune/presentation/ingredientaction/bloc/ingredient_action.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

class IngredientActionParam {
  final IngredientEntity ingredient;
  final RewardedAd? ad;
  final bool isShowAd;

  IngredientActionParam({
    required this.ingredient,
    required this.ad,
    required this.isShowAd,
  });

  factory IngredientActionParam.empty() => IngredientActionParam(
        ingredient: IngredientEntity.empty(),
        ad: null,
        isShowAd: false,
      );
}

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
  const _IngredientActionPage({
    Key? key,
  }) : super(key: key);

  @override
  State<_IngredientActionPage> createState() => _IngredientActionPageState();
}

class _IngredientActionPageState extends State<_IngredientActionPage> {
  final _router = serviceLocator<FortuneRouter>().router;

  late IngredientActionBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<IngredientActionBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocSideEffectListener<IngredientActionBloc, IngredientActionSideEffect>(
      listener: (context, sideEffect) {
        if (sideEffect is IngredientActionError) {
          dialogService.showErrorDialog(context, sideEffect.error);
        } else if (sideEffect is IngredientProcessAction) {
          final ingredient = sideEffect.param.ingredient;
          final ad = sideEffect.param.ad;
          switch (ingredient.type) {
            case IngredientType.coin:
              FortuneLogger.info("ad: ${sideEffect.param.ad}, isShowAd: ${sideEffect.param.isShowAd}");
              try {
                if (ad != null && sideEffect.param.isShowAd) {
                  ad.show(
                    onUserEarnedReward: (_, reward) {
                      FortuneLogger.info("#1 광고 보기 완료: ${reward.type}, ${reward.amount}");
                      _bloc.add(IngredientActionShowAdCounting());
                    },
                  );
                } else {
                  _bloc.add(IngredientActionShowAdCounting());
                }
              } catch (e) {
                FortuneLogger.info("#2 광고 없음: $e");
                _router.pop(context, true);
              }
              break;
            default:
              _router.pop(context, true);
          }
        } else if (sideEffect is IngredientAdShowComplete) {
          _router.pop(context, true);
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
        return Container(color: Colors.black.withOpacity(0.5));
      default:
        return Container(color: Colors.black.withOpacity(0.5));
    }
  }
}
