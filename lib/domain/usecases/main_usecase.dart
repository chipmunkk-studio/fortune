import 'package:foresh_flutter/core/util/usecase.dart';
import 'package:foresh_flutter/domain/entities/main_entity.dart';
import 'package:foresh_flutter/domain/repositories/marker_repository.dart';

class MainUseCase implements UseCase1<MainEntity, RequestMainParams> {
  final MainRepository repository;

  MainUseCase(this.repository);

  @override
  Future<FortuneResult<MainEntity>> call(RequestMainParams params) async {
    return await repository.getMarkerList(params);
  }
}

class RequestMainParams {
  double? latitude;
  double? longitude;

  RequestMainParams({
    required this.latitude,
    required this.longitude,
  });
}
