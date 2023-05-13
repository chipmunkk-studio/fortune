import 'package:foresh_flutter/core/error/fortune_error_mapper.dart';
import 'package:foresh_flutter/core/network/api/fortune_response.dart';
import 'package:foresh_flutter/core/network/api/request/request_main.dart';
import 'package:foresh_flutter/core/network/api/request/request_post_marker.dart';
import 'package:foresh_flutter/core/util/usecase.dart';
import 'package:foresh_flutter/data/datasources/main_datasource.dart';
import 'package:foresh_flutter/domain/entities/inventory_entity.dart';
import 'package:foresh_flutter/domain/entities/main_entity.dart';
import 'package:foresh_flutter/domain/entities/marker/marker_click_entity.dart';
import 'package:foresh_flutter/domain/repositories/marker_repository.dart';
import 'package:foresh_flutter/domain/usecases/click_marker_usecase.dart';
import 'package:foresh_flutter/domain/usecases/main_usecase.dart';

class MainRepositoryImpl implements MainRepository {
  final MainDataSource markerRemoteDataSource;
  final FortuneErrorMapper errorMapper;

  MainRepositoryImpl({
    required this.markerRemoteDataSource,
    required this.errorMapper,
  });

  @override
  Future<FortuneResult<MarkerClickEntity>> clickMarker(RequestPostMarkerParams params) async {
    final remoteData = await markerRemoteDataSource
        .clickMarker(
          RequestPostMarker(
            id: params.id,
            latitude: params.latitude,
            longitude: params.longitude,
          ),
        )
        .toRemoteDomainData(errorMapper);
    return remoteData;
  }

  @override
  Future<FortuneResult<MainEntity>> getMarkerList(RequestMainParams params) async {
    final remoteData = await markerRemoteDataSource
        .getMarkerList(
          RequestMain(
            latitude: params.latitude,
            longitude: params.longitude,
          ),
        )
        .toRemoteDomainData(errorMapper);
    return remoteData;
  }

  @override
  Future<FortuneResult<InventoryEntity>> getInventory() async {
    final remoteData = await markerRemoteDataSource.getInventory().toRemoteDomainData(errorMapper);
    return remoteData;
  }
}
