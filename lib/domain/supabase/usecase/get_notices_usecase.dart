import 'package:dartz/dartz.dart';
import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/core/util/usecase.dart';
import 'package:foresh_flutter/domain/supabase/entity/common/notices_entity.dart';
import 'package:foresh_flutter/domain/supabase/repository/support_repository.dart';

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
