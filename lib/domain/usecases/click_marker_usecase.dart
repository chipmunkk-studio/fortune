import 'package:foresh_flutter/core/util/usecase.dart';
import 'package:foresh_flutter/domain/entities/marker/marker_click_entity.dart';
import 'package:foresh_flutter/domain/repositories/marker_repository.dart';

class ClickMarkerUseCase implements UseCase1<void, RequestPostMarkerParams> {
  final MainRepository repository;

  ClickMarkerUseCase(this.repository);

  @override
  Future<FortuneResult<MarkerClickEntity>> call(RequestPostMarkerParams params) async {
    return await repository.clickMarker(params);
  }
}

class RequestPostMarkerParams {
  int id;
  double latitude;
  double longitude;

  RequestPostMarkerParams({
    required this.id,
    required this.latitude,
    required this.longitude,
  });
}
