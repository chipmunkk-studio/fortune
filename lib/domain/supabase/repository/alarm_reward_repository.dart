import 'package:fortune/data/supabase/request/request_alarm_reward_history.dart';
import 'package:fortune/data/supabase/service_ext.dart';
import 'package:fortune/domain/supabase/entity/eventnotice/alarm_rewards_entity.dart';
import 'package:fortune/domain/supabase/entity/eventnotice/alarm_rewards_history_entity.dart';
import 'package:fortune/domain/supabase/entity/fortune_user_entity.dart';
import 'package:fortune/domain/supabase/entity/ingredient_entity.dart';

abstract class AlarmRewardRepository {
  // 사용자 리워드 히스토리 추가.
  Future<AlarmRewardHistoryEntity> insertRewardHistory({
    required FortuneUserEntity user,
    required AlarmRewardInfoEntity alarmRewardInfo,
    required IngredientEntity ingredient,
  });

  // 타입으로 리워드 정보 조회.
  Future<AlarmRewardInfoEntity> findRewardInfoByType(
    AlarmRewardType type,
  );

  // 리워드 정보 업데이트.
  Future<AlarmRewardHistoryEntity> update(
    int id, {
    required RequestAlarmRewardHistory request,
  });

  Future<void> deleteOldHistory(int userId);
}
