import 'package:fortune/data/remote/api/fortune_response.dart';
import 'package:fortune/data/remote/api/service/marker_service.dart';
import 'package:fortune/data/remote/request/request_obtain_marker.dart';
import 'package:fortune/data/remote/response/marker_list_response.dart';
import 'package:fortune/data/remote/response/marker_obtain_response.dart';
import 'package:fortune/domain/entity/marker_list_entity.dart';
import 'package:fortune/domain/entity/marker_obtain_entity.dart';

abstract class MarkerDataSource {
  Future<MarkerListEntity> markerList(String geoLocation);

  Future<MarkerObtainEntity> obtainMarker(
    RequestObtainMarker request,
    String location,
  );
}

class MarkerDataSourceImpl extends MarkerDataSource {
  final MarkerService markerService;

  MarkerDataSourceImpl({
    required this.markerService,
  });

  @override
  Future<MarkerListEntity> markerList(String geoLocation) async {
    return await markerService.markerList(geoLocation).then(
          (value) => MarkerListResponse.fromJson(
            value.toResponseData(),
          ),
        );
  }

  @override
  Future<MarkerObtainEntity> obtainMarker(
    RequestObtainMarker request,
    String location,
  ) async {
    return await markerService
        .obtainMarker(
          request,
          location,
        )
        .then(
          (value) => MarkerObtainResponse.fromJson(
            value.toResponseData(),
          ),
        );
  }
}
