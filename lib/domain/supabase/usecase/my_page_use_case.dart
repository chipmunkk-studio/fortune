import 'package:dartz/dartz.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/core/util/usecase.dart';
import 'package:fortune/domain/local/local_respository.dart';
import 'package:fortune/domain/supabase/entity/my_page_view_entity.dart';
import 'package:fortune/domain/supabase/repository/support_repository.dart';
import 'package:fortune/domain/supabase/repository/user_repository.dart';

class MyPageUseCase implements UseCase0<MyPageViewEntity> {
  final UserRepository userRepository;
  final LocalRepository localRepository;
  final SupportRepository supportRepository;

  MyPageUseCase({
    required this.localRepository,
    required this.userRepository,
    required this.supportRepository,
  });

  @override
  Future<FortuneResult<MyPageViewEntity>> call() async {
    try {
      final user = await userRepository.findUserByEmailNonNull();
      final notices = await supportRepository.getNotices();
      final isAllowPushAlarm = await localRepository.getAllowPushAlarm();

      final bool hasNewNotice = notices.any((element) => element.isNew == true);

      final entity = MyPageViewEntity(
        user: user,
        isAllowPushAlarm: isAllowPushAlarm,
        hasNewNotice: hasNewNotice,
      );
      return Right(entity);
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }
}
