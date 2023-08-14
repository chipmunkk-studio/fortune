import 'package:dartz/dartz.dart';
import 'package:foresh_flutter/core/error/failure/custom_failure.dart';
import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/core/util/usecase.dart';
import 'package:foresh_flutter/data/supabase/request/request_alarm_reward_history.dart';
import 'package:foresh_flutter/data/supabase/request/request_obtain_history.dart';
import 'package:foresh_flutter/domain/supabase/entity/eventnotice/alarm_rewards_history_entity.dart';
import 'package:foresh_flutter/domain/supabase/repository/alarm_reward_repository.dart';
import 'package:foresh_flutter/domain/supabase/repository/obtain_history_repository.dart';
import 'package:foresh_flutter/domain/supabase/repository/user_repository.dart';

class ObtainAlarmRewardUseCase implements UseCase1<void, int> {
  final UserRepository userRepository;
  final AlarmRewardRepository rewardRepository;
  final ObtainHistoryRepository obtainHistoryRepository;

  ObtainAlarmRewardUseCase({
    required this.userRepository,
    required this.obtainHistoryRepository,
    required this.rewardRepository,
  });

  @override
  Future<FortuneResult<AlarmRewardHistoryEntity>> call(int id) async {
    try {
      final reward = await rewardRepository.findRewardHistoryById(id);

      if (reward.isReceive) {
        throw const CustomFailure(errorDescription: '이미 지급 받은 리워드 입니다.');
      }

      // 히스토리 등록.
      await obtainHistoryRepository.insertObtainHistory(
        request: RequestObtainHistory.insert(
          ingredientId: reward.ingredients.id,
          userId: reward.user.id,
          nickName: reward.user.nickname,
          ingredientName: reward.ingredients.name,
          isReward: true,
        ),
      );

      // 리워드 받기.
      final updateReward = await rewardRepository.update(
        id,
        request: RequestAlarmRewardHistory(
          isReceive: true,
        ),
      );

      return Right(updateReward);
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }
}
