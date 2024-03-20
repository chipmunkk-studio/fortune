import 'package:dartz/dartz.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/core/util/usecase.dart';
import 'package:fortune/data/supabase/response/fortune_user_response.dart';
import 'package:fortune/domain/supabase/repository/alarm_feeds_repository.dart';
import 'package:fortune/domain/supabase/repository/user_repository.dart';

class ReadAlarmFeedUseCase implements UseCase0<void> {
  final UserRepository userRepository;
  final AlarmFeedsRepository alarmFeedsRepository;

  ReadAlarmFeedUseCase({
    required this.userRepository,
    required this.alarmFeedsRepository,
  });

  @override
  Future<FortuneResultDeprecated<void>> call() async {
    try {
      final user = await userRepository.findUserByEmailNonNull(columnsToSelect: [UserColumn.id]);
      await alarmFeedsRepository.readAllAlarm(user.id);
      return const Right(null);
    } on FortuneFailureDeprecated catch (e) {
      return Left(e);
    }
  }
}
