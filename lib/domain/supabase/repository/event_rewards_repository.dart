import 'package:foresh_flutter/data/supabase/service/service_ext.dart';
import 'package:foresh_flutter/domain/supabase/entity/eventnotice/alarm_rewards_entity.dart';
import 'package:foresh_flutter/domain/supabase/entity/eventnotice/alarm_rewards_history_entity.dart';
import 'package:foresh_flutter/domain/supabase/entity/fortune_user_entity.dart';
import 'package:foresh_flutter/domain/supabase/entity/ingredient_entity.dart';

abstract class AlarmRewardsRepository {
  // 사용자 리워드 히스토리 추가.
  Future<AlarmRewardHistoryEntity> insertRewardHistory({
    required FortuneUserEntity user,
    required AlarmRewardInfoEntity alarmRewardInfo,
    required IngredientEntity ingredient,
  });

  Future<AlarmRewardInfoEntity> findRewardInfoByType(
    AlarmRewardType type,
  );
}
