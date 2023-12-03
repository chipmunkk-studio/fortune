import 'package:fortune/domain/supabase/entity/fortune_user_entity.dart';
import 'package:fortune/domain/supabase/entity/ingredient_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

part 'ingredient_action_param.freezed.dart';

@freezed
class IngredientActionParam with _$IngredientActionParam {
  factory IngredientActionParam({
    required IngredientEntity ingredient,
    required RewardedAd? ad,
    required bool isShowAd,
    required FortuneUserEntity? user,
  }) = _IngredientActionParam;

  factory IngredientActionParam.initial() => IngredientActionParam(
        ingredient: IngredientEntity.empty(),
        user: FortuneUserEntity.empty(),
        ad: null,
        isShowAd: false,
      );
}
