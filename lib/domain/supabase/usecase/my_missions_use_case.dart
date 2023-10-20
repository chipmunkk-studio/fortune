import 'package:dartz/dartz.dart';
import 'package:fortune/core/error/fortune_app_failures.dart';
import 'package:fortune/core/util/usecase.dart';
import 'package:fortune/domain/supabase/entity/my_missions_view_entity.dart';
import 'package:fortune/domain/supabase/repository/mission_respository.dart';
import 'package:fortune/domain/supabase/repository/user_repository.dart';

class MyMissionsUseCase implements UseCase0<MainViewEntity> {
  final MissionsRepository missionsRepository;
  final UserRepository userRepository;

  MyMissionsUseCase({
    required this.missionsRepository,
    required this.userRepository,
  });

  @override
  Future<FortuneResult<MainViewEntity>> call() async {
    try {
      final user = await userRepository.findUserByEmailNonNull();
      final missions = await missionsRepository.getMissionClearUsersByUserId(user.id);
      return Right(
        MainViewEntity(
          missions: missions,
        ),
      );
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }
}