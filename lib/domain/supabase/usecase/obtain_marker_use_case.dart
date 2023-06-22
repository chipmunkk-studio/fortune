import 'package:dartz/dartz.dart';
import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/core/util/usecase.dart';
import 'package:foresh_flutter/domain/supabase/entity/fortune_user_entity.dart';
import 'package:foresh_flutter/domain/supabase/repository/marker_respository.dart';

class ObtainMarkerUseCase implements UseCase1<FortuneUserEntity, int> {
  final MarkerRepository markerRepository;

  ObtainMarkerUseCase({
    required this.markerRepository,
  });

  @override
  Future<FortuneResult<FortuneUserEntity>> call(int param) async {
    try {
      final updateUser = await markerRepository.obtainMarker(param);
      return Right(updateUser);
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }
}
