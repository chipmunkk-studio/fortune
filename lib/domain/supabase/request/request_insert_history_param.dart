import 'package:fortune/data/supabase/service/service_ext.dart';

class RequestInsertHistoryParam {
  final int ingredientId;
  final int userId;
  final int markerId;
  final String krLocationName;
  final String enLocationName;
  final String ingredientName;
  final String nickname;
  final IngredientType ingredientType;

  RequestInsertHistoryParam({
    required this.ingredientId,
    required this.userId,
    required this.markerId,
    required this.krLocationName,
    required this.enLocationName,
    required this.ingredientName,
    required this.nickname,
    required this.ingredientType,
  });
}
