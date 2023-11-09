import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/core/navigation/fortune_app_router.dart';
import 'package:fortune/core/util/logger.dart';
import 'package:fortune/core/util/mixpanel.dart';
import 'package:fortune/core/util/textstyle.dart';
import 'package:fortune/core/widgets/fortune_scaffold.dart';
import 'package:fortune/data/supabase/service_ext.dart';
import 'package:fortune/di.dart';
import 'package:fortune/domain/supabase/entity/fortune_user_entity.dart';
import 'package:fortune/domain/supabase/entity/ingredient_entity.dart';
import 'package:fortune/presentation/ingredientaction/bloc/ingredient_action.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

class IngredientActionParam {
  final IngredientEntity ingredient;
  final RewardedAd? ad;
  final bool isShowAd;
  final FortuneUserEntity? user;

  IngredientActionParam({
    required this.ingredient,
    required this.ad,
    required this.isShowAd,
    required this.user,
  });

  factory IngredientActionParam.empty() => IngredientActionParam(
        ingredient: IngredientEntity.empty(),
        user: FortuneUserEntity.empty(),
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
      listener: (context, sideEffect) {
        if (sideEffect is IngredientActionError) {
          dialogService.showAppErrorDialog(context, sideEffect.error);
        } else if (sideEffect is IngredientProcessAction) {
          final ingredient = sideEffect.param.ingredient;
          final ad = sideEffect.param.ad;
          switch (ingredient.type) {
            case IngredientType.coin:
              FortuneLogger.info("ad: ${sideEffect.param.ad}, isShowAd: ${sideEffect.param.isShowAd}");
              try {
                if (sideEffect.param.isShowAd) {
                  if (ad != null) {
                    ad.show(
                      onUserEarnedReward: (_, reward) {
                        _mixpanelTracker.trackEvent('광고 보기 완료', properties: {
                          'email': sideEffect.param.user?.email,
                        });
                        FortuneLogger.info("#1 광고 보기 완료: ${reward.type}, ${reward.amount}");
                        _bloc.add(IngredientActionShowAdCounting());
                      },
                    );
                  } else {
                    _mixpanelTracker.trackEvent('광고 없음 #1', properties: {
                      'email': sideEffect.param.user?.email,
                    });
                    _router.pop(context, false);
                  }
                } else {
                  _bloc.add(IngredientActionShowAdCounting());
                }
              } catch (e) {
                _mixpanelTracker.trackEvent('광고 없음 #2', properties: {
                  'email': sideEffect.param.user?.email,
                });
                _router.pop(context, false);
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
        return FortuneScaffold(
          appBar: FortuneCustomAppBar.leadingAppBar(
            context,
            backgroundColor: Colors.black.withOpacity(0.5),
          ),
          backgroundColor: Colors.black.withOpacity(0.5),
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
}
