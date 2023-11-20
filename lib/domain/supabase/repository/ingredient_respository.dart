import 'package:fortune/data/supabase/service_ext.dart';
import 'package:fortune/domain/supabase/entity/eventnotice/alarm_rewards_entity.dart';
import 'package:fortune/domain/supabase/entity/ingredient_entity.dart';

abstract class IngredientRepository {
  // 재료들 모두 가져오기
  Future<List<IngredientEntity>> findAllIngredients();

  // 재료 랜덤으로 하나 가져오기
  Future<IngredientEntity> generateIngredientByRewardInfoType(AlarmRewardInfoEntity rewardInfo);

  // 타입에 따라 재료 가져오기.
  Future<List<IngredientEntity>> findIngredientsByType(List<IngredientType> type);
}
