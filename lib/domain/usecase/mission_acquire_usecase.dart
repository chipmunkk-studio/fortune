import 'package:dartz/dartz.dart';
import 'package:fortune/core/util/usecase2.dart';
import 'package:fortune/data/error/fortune_error.dart';
import 'package:fortune/domain/entity/fortune_user_entity.dart';
import 'package:fortune/domain/repository/mission_repository.dart';

class MissionAcquireUseCase implements UseCase2<FortuneUserEntity, String, int> {
  final MissionRepository missionRepository;

  MissionAcquireUseCase({
    required this.missionRepository,
  });

  @override
  Future<FortuneResult<FortuneUserEntity>> call(String id, int ts) async {
    try {
      final response = await missionRepository.missionAcquire(
        id: id,
        ts: ts,
      );
      return Right(response);
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }
}
