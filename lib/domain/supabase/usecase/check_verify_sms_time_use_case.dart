import 'package:dartz/dartz.dart';
import 'package:foresh_flutter/core/error/failure/common_failure.dart';
import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/core/message_ext.dart';
import 'package:foresh_flutter/core/util/usecase.dart';
import 'package:foresh_flutter/domain/local/local_respository.dart';
import 'package:foresh_flutter/domain/supabase/entity/sms_verify_remain_time_entity.dart';

class CheckVerifySmsTimeUseCase implements UseCase0<SmsVerifyRemainTimeEntity> {
  final LocalRepository localRepository;

  CheckVerifySmsTimeUseCase({
    required this.localRepository,
  });

  @override
  Future<FortuneResult<SmsVerifyRemainTimeEntity>> call() async {
    try {
      final entity = await _getTimeDifference();
      if (!entity.isEnable) {
        throw CommonFailure(
          errorMessage: FortuneTr.msgRequestSmsVerifyCode(
            entity.remainMinute.toString(),
            entity.remainSecond.toString(),
          ),
        );
      }
      return Right(entity);
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }

  Future<SmsVerifyRemainTimeEntity> _getTimeDifference() async {
    const int threeMinutesInMilliseconds = 3 * 60 * 1000;

    final enable = SmsVerifyRemainTimeEntity(
      remainMinute: 0,
      remainSecond: 0,
      isEnable: true,
    );

    final lastSMSTime = await localRepository.getVerifySmsTime();

    if (lastSMSTime == 0) {
      return enable;
    }

    final currentTime = DateTime.now().millisecondsSinceEpoch;
    final difference = currentTime - lastSMSTime;

    if (difference >= threeMinutesInMilliseconds) {
      return enable;
    } else {
      int remainingTime = threeMinutesInMilliseconds - difference;
      int remainingMinutes = remainingTime ~/ (60 * 1000);
      int remainingSeconds = (remainingTime % (60 * 1000)) ~/ 1000;

      return SmsVerifyRemainTimeEntity(
        remainMinute: remainingMinutes,
        remainSecond: remainingSeconds,
        isEnable: false,
      );
    }
  }
}