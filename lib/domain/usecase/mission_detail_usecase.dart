import 'package:dartz/dartz.dart';
import 'package:fortune/core/util/usecase2.dart';
import 'package:fortune/data/error/fortune_error.dart';
import 'package:fortune/domain/entity/mission_entity.dart';
import 'package:fortune/domain/entity/mission_marker_entity.dart';
import 'package:fortune/domain/repository/mission_repository.dart';

class MissionDetailUseCase implements UseCase1<MissionEntity, String> {
  final MissionRepository missionRepository;

  MissionDetailUseCase({
    required this.missionRepository,
  });

  @override
  Future<FortuneResult<MissionEntity>> call(String id) async {
    try {
      final response = await missionRepository.missionDetail(id);
      final missionMarkers = response.items;
      while (missionMarkers.length < 7) {
        missionMarkers.add(MissionMarkerEntity.empty());
      }
      return Right(response);
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }
}
