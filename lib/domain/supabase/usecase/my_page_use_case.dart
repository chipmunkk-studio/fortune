import 'package:dartz/dartz.dart';
import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/core/util/usecase.dart';
import 'package:foresh_flutter/domain/local/local_respository.dart';
import 'package:foresh_flutter/domain/supabase/entity/my_page_view_entity.dart';
import 'package:foresh_flutter/domain/supabase/repository/user_repository.dart';

class MyPageUseCase implements UseCase0<MyPageViewEntity> {
  final UserRepository userRepository;
  final LocalRepository localRepository;

  MyPageUseCase({
    required this.localRepository,
    required this.userRepository,
  });

  @override
  Future<FortuneResult<MyPageViewEntity>> call() async {
    try {
      final user = await userRepository.findUserByPhoneNonNull();
      final isAllowPushAlarm = await localRepository.getAllowPushAlarm();
      final entity = MyPageViewEntity(
        user: user,
        isAllowPushAlarm: isAllowPushAlarm,
      );
      return Right(entity);
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }
}
