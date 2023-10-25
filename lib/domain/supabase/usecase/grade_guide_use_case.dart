import 'package:dartz/dartz.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/core/util/usecase.dart';
import 'package:fortune/data/supabase/response/fortune_user_response.dart';
import 'package:fortune/domain/supabase/entity/grade_guide_view_entity.dart';
import 'package:fortune/domain/supabase/repository/user_repository.dart';

class GradeGuideUseCase implements UseCase0<GradeGuideViewEntity> {
  final UserRepository userRepository;

  GradeGuideUseCase({
    required this.userRepository,
  });

  @override
  Future<FortuneResult<GradeGuideViewEntity>> call() async {
    try {
      final user = await userRepository.findUserByEmailNonNull(
        columnsToSelect: [
          UserColumn.level,
          UserColumn.markerObtainCount,
          UserColumn.nickname,
        ],
      );
      final entity = GradeGuideViewEntity(
        user: user,
      );
      return Right(entity);
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }
}
