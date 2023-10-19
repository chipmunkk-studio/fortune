import 'package:dartz/dartz.dart';
import 'package:fortune/core/error/failure/common_failure.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/core/message_ext.dart';
import 'package:fortune/core/util/usecase.dart';
import 'package:fortune/data/supabase/request/request_alarm_reward_history.dart';
import 'package:fortune/data/supabase/request/request_obtain_history.dart';
import 'package:fortune/domain/supabase/entity/eventnotice/alarm_feeds_entity.dart';
import 'package:fortune/domain/supabase/repository/alarm_feeds_repository.dart';
import 'package:fortune/domain/supabase/repository/alarm_reward_repository.dart';
import 'package:fortune/domain/supabase/repository/obtain_history_repository.dart';
import 'package:fortune/domain/supabase/repository/user_repository.dart';

class ReceiveAlarmRewardUseCase implements UseCase1<List<AlarmFeedsEntity>, AlarmFeedsEntity> {
  final UserRepository userRepository;
  final AlarmRewardRepository rewardRepository;
  final AlarmFeedsRepository alarmFeedsRepository;
  final ObtainHistoryRepository historyRepository;

  ReceiveAlarmRewardUseCase({
    required this.userRepository,
    required this.rewardRepository,
    required this.alarmFeedsRepository,
    required this.historyRepository,
  });

  @override
  Future<FortuneResult<List<AlarmFeedsEntity>>> call(AlarmFeedsEntity param) async {
    try {
      final user = await userRepository.findUserByEmailNonNull();
      final ingredients = param.reward.ingredients;
      // 이미 받은 보상 일 경우.
      if (param.isReceive) {
        throw CommonFailure(errorMessage: FortuneTr.msgRewardCompleted);
      }
      // 마커 획득 히스토리 추가.
      await historyRepository.insertObtainHistory(
        request: RequestObtainHistory.insert(
          ingredientId: ingredients.id,
          userId: user.id,
          nickName: user.nickname,
          enIngredientName: ingredients.enName,
          krIngredientName: ingredients.krName,
          isReward: true,
        ),
      );
      // 읽음 처리.
      await rewardRepository.update(
        param.reward.id,
        request: RequestAlarmRewardHistory(
          isReceive: true,
        ),
      );
      // 새로운 피드 리스트 반환.
      final newAlarms = await alarmFeedsRepository.findAllAlarmsByUserId(user.id);
      return Right(newAlarms);
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }
}
