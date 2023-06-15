import 'package:foresh_flutter/domain/supabase/entity/fortune_user_entity.dart';
import 'package:foresh_flutter/domain/supabase/entity/ingredient_entity.dart';

class ObtainHistoryEntity {
  final int id;
  final String markerId;
  final FortuneUserEntity user;
  final IngredientEntity ingredient;
  final String nickName;
  final String ingredientName;
  final String krLocationName;
  final String enLocationName;
  final String createdAt;

  ObtainHistoryEntity({
    required this.id,
    required this.markerId,
    required this.user,
    required this.ingredient,
    required this.createdAt,
    required this.ingredientName,
    required this.krLocationName,
    required this.enLocationName,
    required this.nickName,
  });
}
