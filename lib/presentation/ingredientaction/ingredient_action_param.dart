import 'package:fortune/domain/supabase/entity/fortune_user_entity.dart';
import 'package:fortune/domain/supabase/entity/ingredient_entity.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

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

  IngredientActionParam copyWith({
    IngredientEntity? ingredient,
    RewardedAd? ad,
    bool? isShowAd,
    FortuneUserEntity? user,
  }) {
    return IngredientActionParam(
      ingredient: ingredient ?? this.ingredient,
      ad: ad ?? this.ad,
      isShowAd: isShowAd ?? this.isShowAd,
      user: user ?? this.user,
    );
  }
}
