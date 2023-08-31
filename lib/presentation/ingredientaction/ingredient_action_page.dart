import 'package:flutter/material.dart';
import 'package:foresh_flutter/core/util/logger.dart';
import 'package:foresh_flutter/data/supabase/service/service_ext.dart';
import 'package:foresh_flutter/di.dart';
import 'package:foresh_flutter/domain/supabase/entity/ingredient_entity.dart';
import 'package:foresh_flutter/presentation/fortune_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class IngredientActionParam {
  final IngredientEntity ingredient;
  final RewardedAd? ad;

  IngredientActionParam({
    required this.ingredient,
    required this.ad,
  });
}

class IngredientActionPage extends StatefulWidget {
  final IngredientActionParam param;

  const IngredientActionPage(
    this.param, {
    Key? key,
  }) : super(key: key);

  @override
  State<IngredientActionPage> createState() => _IngredientActionPageState();
}

class _IngredientActionPageState extends State<IngredientActionPage> {
  final _router = serviceLocator<FortuneRouter>().router;

  @override
  Widget build(BuildContext context) {
    return _buildProcessWidgetOnType();
  }

  _buildProcessWidgetOnType() {
    final entity = widget.param;
    switch (entity.ingredient.type) {
      case IngredientType.ticket:
        entity.ad?.show(onUserEarnedReward: (_, reward) {
          FortuneLogger.debug("광고 보기 완료: ${reward.type}, ${reward.amount}");
          _router.pop(context, true);
        });
        return Container();
      default:
        _router.pop(context, true);
        return Container();
    }
  }
}
