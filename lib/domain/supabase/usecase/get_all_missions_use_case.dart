import 'package:dartz/dartz.dart';
import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/core/util/usecase.dart';
import 'package:foresh_flutter/domain/supabase/entity/mission_entity.dart';
import 'package:foresh_flutter/domain/supabase/repository/mission_respository.dart';

class GetAllMissionsUseCase implements UseCase0<List<MissionEntity>> {
  final MissionRepository missionRepository;

  GetAllMissionsUseCase({
    required this.missionRepository,
  });

  @override
  Future<FortuneResult<List<MissionEntity>>> call() async {
    try {
      final missions = await missionRepository.getAllMissions();
      return Right(missions);
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }
}
