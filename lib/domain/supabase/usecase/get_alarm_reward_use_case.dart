import 'package:dartz/dartz.dart';
import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/core/util/usecase.dart';
import 'package:foresh_flutter/domain/supabase/entity/eventnotice/alarm_rewards_history_entity.dart';
import 'package:foresh_flutter/domain/supabase/repository/alarm_reward_repository.dart';

class GetAlarmRewardUseCase implements UseCase1<AlarmRewardHistoryEntity, int> {
  final AlarmRewardRepository alarmRewardRepository;

  GetAlarmRewardUseCase({
    required this.alarmRewardRepository,
  });

  @override
  Future<FortuneResult<AlarmRewardHistoryEntity>> call(int id) async {
    try {
      final reward = await alarmRewardRepository.findRewardHistoryById(id);
      return Right(reward);
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }
}
