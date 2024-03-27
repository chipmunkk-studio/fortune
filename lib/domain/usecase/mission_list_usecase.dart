import 'package:dartz/dartz.dart';
import 'package:fortune/core/util/usecase2.dart';
import 'package:fortune/data/error/fortune_error.dart';
import 'package:fortune/domain/entity/fortune_user_entity.dart';
import 'package:fortune/domain/entity/mission_list_entity.dart';
import 'package:fortune/domain/repository/mission_repository.dart';

class MissionListUseCase implements UseCase0<MissionListEntity> {
  final MissionRepository missionRepository;

  MissionListUseCase({
    required this.missionRepository,
  });

  @override
  Future<FortuneResult<MissionListEntity>> call() async {
    try {
      final response = await missionRepository.missionList();
      return Right(response);
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }
}
