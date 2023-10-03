import 'package:dartz/dartz.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/core/util/usecase.dart';
import 'package:fortune/domain/supabase/entity/support/notices_entity.dart';
import 'package:fortune/domain/supabase/repository/support_repository.dart';

class GetNoticesUseCase implements UseCase0<List<NoticesEntity>> {
  final SupportRepository repository;

  GetNoticesUseCase({required this.repository});

  @override
  Future<FortuneResult<List<NoticesEntity>>> call() async {
    try {
      final notices = await repository.getNotices();
      return Right(notices);
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }
}
