import 'package:fortune/data/error/fortune_error_mapper.dart';
import 'package:fortune/data/remote/api/fortune_response.dart';
import 'package:fortune/data/remote/datasource/marker_datasource.dart';
import 'package:fortune/domain/entity/marker_list_entity.dart';
import 'package:fortune/domain/repository/marker_repository.dart';

class MarkerRepositoryImpl implements MarkerRepository {
  final MarkerDataSource markerDataSource;
  final FortuneErrorMapper errorMapper;

  MarkerRepositoryImpl({
    required this.markerDataSource,
    required this.errorMapper,
  });

  @override
  Future<MarkerListEntity> markerList(
    double latitude,
    double longitude,
  ) async {
    try {
      final remoteData = await markerDataSource
          .markerList(
            "$latitude,$longitude",
          )
          .toRemoteDomainData(errorMapper);
      return remoteData;
    } catch (e) {
      rethrow;
    }
  }
}
