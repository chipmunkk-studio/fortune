import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/core/util/logger.dart';
import 'package:foresh_flutter/data/supabase/request/request_event_reward_history.dart';
import 'package:foresh_flutter/data/supabase/service/alarm_reward_history_service.dart';
import 'package:foresh_flutter/data/supabase/service/alarm_reward_info_service.dart';
import 'package:foresh_flutter/data/supabase/service/service_ext.dart';
import 'package:foresh_flutter/domain/supabase/entity/eventnotice/alarm_rewards_entity.dart';
import 'package:foresh_flutter/domain/supabase/entity/eventnotice/alarm_rewards_history_entity.dart';
import 'package:foresh_flutter/domain/supabase/entity/fortune_user_entity.dart';
import 'package:foresh_flutter/domain/supabase/entity/ingredient_entity.dart';
import 'package:foresh_flutter/domain/supabase/repository/event_rewards_repository.dart';

class AlarmRewardRepositoryImpl extends AlarmRewardsRepository {
  final AlarmRewardHistoryService rewardsService;
  final AlarmRewardInfoService eventRewardInfoService;

  AlarmRewardRepositoryImpl({
    required this.rewardsService,
    required this.eventRewardInfoService,
  });

  @override
  Future<AlarmRewardHistoryEntity> insertRewardHistory({
    required FortuneUserEntity user,
    required AlarmRewardInfoEntity alarmRewardInfo,
    required IngredientEntity ingredient,
  }) async {
    try {
      final result = await rewardsService.insertRewardHistory(
        RequestEventRewardHistory.insert(
          eventRewardInfo: alarmRewardInfo.id,
          user: user.id,
          ingredientImage: ingredient.imageUrl,
          ingredientName: ingredient.name,
        ),
      );
      return result;
    } on FortuneFailure catch (e) {
      throw e.handleFortuneFailure(
        description: '이벤트 리워드 추가 실패',
      );
    }
  }

  @override
  Future<AlarmRewardInfoEntity> findRewardInfoByType(AlarmRewardType type) async {
    try {
      final result = await eventRewardInfoService.findEventRewardsByType(type.name);
      return result;
    } on FortuneFailure catch (e) {
      throw e.handleFortuneFailure(
        description: '이벤트 리워드를 찾을 수 없습니다',
      );
    }
  }
}
