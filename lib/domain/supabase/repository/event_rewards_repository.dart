import 'package:foresh_flutter/data/supabase/service/service_ext.dart';
import 'package:foresh_flutter/domain/supabase/entity/eventnotice/event_rewards_entity.dart';
import 'package:foresh_flutter/domain/supabase/entity/eventnotice/event_rewards_history_entity.dart';
import 'package:foresh_flutter/domain/supabase/entity/fortune_user_entity.dart';
import 'package:foresh_flutter/domain/supabase/entity/ingredient_entity.dart';

abstract class EventRewardsRepository {
  // 사용자 리워드 히스토리 추가.
  Future<EventRewardHistoryEntity> insertRewardHistory({
    required FortuneUserEntity user,
    required EventRewardInfoEntity eventRewardInfo,
    required IngredientEntity ingredient,
  });

  Future<EventRewardInfoEntity> findRewardInfoByType(
    EventRewardType type,
  );
}
