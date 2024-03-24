import 'package:chopper/chopper.dart';

part 'marker_service.chopper.dart';

@ChopperApi(baseUrl: "api/v1/markers/")
abstract class MarkerService extends ChopperService {
  static MarkerService create([ChopperClient? client]) => _$MarkerService(client);

  /// 마커리스트
  @Get()
  Future<Response> markerList(@Header('geoLocation') String geoLocation);
}
