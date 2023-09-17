import 'package:fortune/domain/supabase/entity/fortune_user_entity.dart';
import 'package:fortune/domain/supabase/entity/ingredient_entity.dart';

class ObtainHistoryEntity {
  final int id;
  final String markerId;
  final FortuneUserEntity user;
  final IngredientEntity ingredient;
  final String nickName;
  final String ingredientName;
  final String locationName;
  final String createdAt;
  final bool isReward;

  ObtainHistoryEntity({
    required this.id,
    required this.markerId,
    required this.user,
    required this.ingredient,
    required this.createdAt,
    required this.ingredientName,
    required this.locationName,
    required this.nickName,
    required this.isReward,
  });
}

abstract class ObtainHistoryPagingViewItem {}

class ObtainHistoryContentViewItem extends ObtainHistoryPagingViewItem {
  final int id;
  final String markerId;
  final FortuneUserEntity user;
  final IngredientEntity ingredient;
  final String nickName;
  final String ingredientName;
  final String locationName;
  final String createdAt;

  ObtainHistoryContentViewItem({
    required this.id,
    required this.markerId,
    required this.user,
    required this.ingredient,
    required this.createdAt,
    required this.ingredientName,
    required this.locationName,
    required this.nickName,
  });
}

class ObtainHistoryLoadingViewItem extends ObtainHistoryPagingViewItem {}