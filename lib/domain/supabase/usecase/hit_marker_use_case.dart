import 'package:dartz/dartz.dart';
import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/core/util/usecase.dart';
import 'package:foresh_flutter/domain/supabase/repository/marker_respository.dart';
import 'package:foresh_flutter/domain/supabase/request/request_hit_param.dart';

class HitMarkerUseCase implements UseCase1<void, RequestHitParam> {
  final MarkerRepository markerRepository;

  HitMarkerUseCase({
    required this.markerRepository,
  });

  @override
  Future<FortuneResult<void>> call(RequestHitParam param) async {
    try {
      final result = await markerRepository.hitMarker(param.markerId);
      return Right(result);
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }
}
