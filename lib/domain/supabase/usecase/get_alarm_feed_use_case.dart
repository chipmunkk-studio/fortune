import 'package:dartz/dartz.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/core/util/usecase.dart';
import 'package:fortune/data/supabase/response/alarmfeed/alarm_feeds_response.dart';
import 'package:fortune/data/supabase/response/fortune_user_response.dart';
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
  Future<FortuneResultDeprecated<List<AlarmFeedsEntity>>> call() async {
    try {
      final user = await userRepository.findUserByEmailNonNull(columnsToSelect: [UserColumn.id]);
      final alarms = await alarmFeedsRepository.findAllAlarmsByUserId(
        user.id,
        columnsToSelect: [
          AlarmFeedColumn.type,
          AlarmFeedColumn.createdAt,
          AlarmFeedColumn.headings,
          AlarmFeedColumn.content,
          AlarmFeedColumn.alarmRewards,
        ],
      );
      return Right(alarms);
    } on FortuneFailureDeprecated catch (e) {
      return Left(e);
    }
  }
}
