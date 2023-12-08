import 'package:fortune/domain/supabase/entity/fortune_user_entity.dart';
import 'package:fortune/domain/supabase/entity/ingredient_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

part 'giftbox_action_param.freezed.dart';

@freezed
class GiftboxActionParam with _$GiftboxActionParam {
  factory GiftboxActionParam({
    required IngredientEntity ingredient,
    required RewardedAd? ad,
    required FortuneUserEntity? user,
    required GiftboxType giftType,
  }) = _GiftboxActionParam;

  factory GiftboxActionParam.initial() => GiftboxActionParam(
        ad: null,
        ingredient: IngredientEntity.empty(),
        user: FortuneUserEntity.empty(),
        giftType: GiftboxType.random,
      );
}

enum GiftboxType { random, coin }
