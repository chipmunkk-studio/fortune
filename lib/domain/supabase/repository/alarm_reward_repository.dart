import 'package:foresh_flutter/data/supabase/service/service_ext.dart';
import 'package:foresh_flutter/domain/supabase/entity/eventnotice/alarm_rewards_entity.dart';
import 'package:foresh_flutter/domain/supabase/entity/eventnotice/alarm_rewards_history_entity.dart';
import 'package:foresh_flutter/domain/supabase/entity/fortune_user_entity.dart';
import 'package:foresh_flutter/domain/supabase/entity/ingredient_entity.dart';

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
  // 사용자 리워드 조회.
  Future<AlarmRewardHistoryEntity> findRewardHistoryById(int id);
}
