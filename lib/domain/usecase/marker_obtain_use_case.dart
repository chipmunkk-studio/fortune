import 'package:dartz/dartz.dart';
import 'package:fortune/core/util/usecase2.dart';
import 'package:fortune/data/error/fortune_app_failures.dart';
import 'package:fortune/domain/entity/marker_obtain_entity.dart';
import 'package:fortune/domain/repository/marker_repository.dart';
import 'package:latlong2/latlong.dart';

class MarkerObtainUseCase implements UseCase3<MarkerObtainEntity, String, int, LatLng> {
  final MarkerRepository markerRepository;

  MarkerObtainUseCase({
    required this.markerRepository,
  });

  @override
  Future<FortuneResult<MarkerObtainEntity>> call(
    String id,
    int ts,
    LatLng location,
  ) async {
    try {
      final response = await markerRepository.obtainMarker(
        id: id,
        ts: ts,
        latitude: location.latitude,
        longitude: location.longitude,
      );
      return Right(response);
    } on FortuneFailure catch (e) {
      return Left(e);
    }
  }
}
