import 'package:dartz/dartz.dart';
import 'package:fortune/core/util/usecase2.dart';
import 'package:fortune/data/error/fortune_app_failures.dart';
import 'package:fortune/domain/entity/marker_list_entity.dart';
import 'package:fortune/domain/repository/marker_repository.dart';
import 'package:latlong2/latlong.dart';

class MarkerListUseCase implements UseCase1<MarkerListEntity, LatLng> {
  final MarkerRepository markerRepository;

  MarkerListUseCase({
    required this.markerRepository,
  });

  @override
  Future<FortuneResult<MarkerListEntity>> call(LatLng location) async {
    try {
      final response = await markerRepository.markerList(
        location.latitude,
        location.longitude,
      );
      return Right(response);
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }
}
