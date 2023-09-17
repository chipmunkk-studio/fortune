import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foresh_flutter/core/gen/colors.gen.dart';
import 'package:foresh_flutter/core/util/logger.dart';
import 'package:foresh_flutter/data/supabase/service/service_ext.dart';
import 'package:foresh_flutter/di.dart';
import 'package:foresh_flutter/domain/supabase/entity/ingredient_entity.dart';
import 'package:foresh_flutter/presentation/fortune_router.dart';
import 'package:foresh_flutter/presentation/ingredientaction/bloc/ingredient_action.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

class IngredientActionParam {
  final IngredientEntity ingredient;
  final RewardedAd? ad;

  IngredientActionParam({
    required this.ingredient,
    required this.ad,
  });

  factory IngredientActionParam.empty() => IngredientActionParam(
        ingredient: IngredientEntity.empty(),
        ad: null,
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

  @override
  Widget build(BuildContext context) {
    return BlocSideEffectListener<IngredientActionBloc, IngredientActionSideEffect>(
      listener: (context, sideEffect) {
        if (sideEffect is IngredientActionError) {
          dialogService.showErrorDialog(context, sideEffect.error);
        } else if (sideEffect is IngredientProcesAction) {
          final ingredient = sideEffect.param.ingredient;
          final ad = sideEffect.param.ad;
          switch (ingredient.type) {
            case IngredientType.ticket:
              try{
                if (ad != null) {
                  ad.show(
                    onUserEarnedReward: (_, reward) {
                      FortuneLogger.info("#1 광고 보기 완료: ${reward.type}, ${reward.amount}");
                      _router.pop(context, true);
                    },
                  );
                } else {
                  _router.pop(context, true);
                }
              } catch (e){
                FortuneLogger.info("#2 광고 없음: $e");
                _router.pop(context, true);
              }
              break;
            default:
              _router.pop(context, true);
          }
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
      case IngredientType.ticket:
        return Container(color: ColorName.grey700);
      default:
        return Container();
    }
  }
}
