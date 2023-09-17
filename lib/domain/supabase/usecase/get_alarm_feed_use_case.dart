import 'package:dartz/dartz.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/core/util/usecase.dart';
import 'package:fortune/domain/supabase/entity/eventnotice/alarm_feeds_entity.dart';
import 'package:fortune/domain/supabase/repository/alarm_feeds_repository.dart';
import 'package:fortune/domain/supabase/repository/user_repository.dart';

class GetAlarmFeedUseCase implements UseCase0<List<AlarmFeedsEntity>> {
  final UserRepository userRepository;
  final AlarmFeedsRepository alarmFeedsRepository;

  GetAlarmFeedUseCase({
    required this.userRepository,
    required this.alarmFeedsRepository,
  });

  @override
  Future<FortuneResult<List<AlarmFeedsEntity>>> call() async {
    try {
      final user = await userRepository.findUserByPhoneNonNull();
      final alarms = await alarmFeedsRepository.findAllAlarmsByUserId(user.id);
      return Right(alarms);
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }
}
