import 'package:dartz/dartz.dart';
import 'package:foresh_flutter/core/error/fortune_app_failures.dart';
import 'package:foresh_flutter/core/util/usecase.dart';
import 'package:foresh_flutter/domain/supabase/repository/marker_respository.dart';
import 'package:foresh_flutter/domain/supabase/request/request_re_locate_marker_param.dart';

class ReLocateMarkerUseCase implements UseCase1<void, RequestReLocateMarkerParam> {
  final MarkerRepository markerRepository;

  ReLocateMarkerUseCase({
    required this.markerRepository,
  });

  @override
  Future<FortuneResult<void>> call(RequestReLocateMarkerParam request) async {
    try {
      final marker = await markerRepository.findMarkerById(request.markerId);
      return Right(
        await markerRepository.reLocateMarker(
          marker: marker,
          user: request.user,
        ),
      );
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }
}
