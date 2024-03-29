import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/data/supabase/request/request_alarm_reward_history.dart';
import 'package:fortune/data/supabase/service/alarm_reward_history_service.dart';
import 'package:fortune/data/supabase/service/alarm_reward_info_service.dart';
import 'package:fortune/data/supabase/service_ext.dart';
import 'package:fortune/domain/supabase/entity/eventnotice/alarm_rewards_entity.dart';
import 'package:fortune/domain/supabase/entity/eventnotice/alarm_rewards_history_entity.dart';
import 'package:fortune/domain/supabase/entity/fortune_user_entity.dart';
import 'package:fortune/domain/supabase/entity/ingredient_entity.dart';
import 'package:fortune/domain/supabase/repository/alarm_reward_repository.dart';

class AlarmRewardRepositoryImpl extends AlarmRewardRepository {
  final AlarmRewardHistoryService rewardsService;
  final AlarmRewardInfoService alarmRewardInfoService;

  AlarmRewardRepositoryImpl({
    required this.rewardsService,
    required this.alarmRewardInfoService,
  });

  @override
  Future<AlarmRewardHistoryEntity> insertRewardHistory({
    required FortuneUserEntity user,
    required AlarmRewardInfoEntity alarmRewardInfo,
    required IngredientEntity ingredient,
  }) async {
    try {
      final result = await rewardsService.insertRewardHistory(
        RequestAlarmRewardHistory.insert(
          alarmRewardInfo: alarmRewardInfo.id,
          user: user.id,
          ingredients: ingredient.id,
        ),
      );
      return result;
    } on FortuneFailureDeprecated catch (e) {
      throw e.handleFortuneFailure(
        description: e.description,
      );
    }
  }

  @override
  Future<AlarmRewardInfoEntity> findRewardInfoByType(AlarmRewardType type) async {
    try {
      final rewardInfo = await alarmRewardInfoService.findEventRewardsByType(type.name);
      return rewardInfo;
    } on FortuneFailureDeprecated catch (e) {
      throw e.handleFortuneFailure();
    }
  }

  @override
  Future<AlarmRewardHistoryEntity> update(
    int id, {
    required RequestAlarmRewardHistory request,
  }) async {
    try {
      final result = await rewardsService.update(
        id,
        request: request,
      );
      return result;
    } on FortuneFailureDeprecated catch (e) {
      throw e.handleFortuneFailure();
    }
  }

  @override
  Future<void> deleteOldHistory(int userId) async {
    try {
      return await rewardsService.deleteOldData(userId);
    } on FortuneFailureDeprecated catch (e) {
      throw e.handleFortuneFailure();
    }
  }
}
