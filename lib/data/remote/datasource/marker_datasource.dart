import 'package:fortune/data/remote/api/fortune_response.dart';
import 'package:fortune/data/remote/api/service/marker_service.dart';
import 'package:fortune/data/remote/response/marker_list_response.dart';
import 'package:fortune/domain/entity/marker_list_entity.dart';

abstract class MarkerDataSource {
  Future<MarkerListEntity> markerList(String geoLocation);
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
}
