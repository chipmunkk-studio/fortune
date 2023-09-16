import 'package:dartz/dartz.dart';
import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/core/util/usecase.dart';
import 'package:foresh_flutter/domain/supabase/entity/grade_guide_view_entity.dart';
import 'package:foresh_flutter/domain/supabase/repository/user_repository.dart';

class GradeGuideUseCase implements UseCase0<GradeGuideViewEntity> {
  final UserRepository userRepository;

  GradeGuideUseCase({
    required this.userRepository,
  });

  @override
  Future<FortuneResult<GradeGuideViewEntity>> call() async {
    try {
      final user = await userRepository.findUserByPhoneNonNull();
      final entity = GradeGuideViewEntity(
        user: user,
      );
      return Right(entity);
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }
}
