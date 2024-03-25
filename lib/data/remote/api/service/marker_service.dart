import 'package:chopper/chopper.dart';
import 'package:fortune/data/remote/request/request_obtain_marker.dart';

part 'marker_service.chopper.dart';

@ChopperApi(baseUrl: "api/v1/markers")
abstract class MarkerService extends ChopperService {
  static MarkerService create([ChopperClient? client]) => _$MarkerService(client);

  /// 마커리스트
  @Get()
  Future<Response> markerList(@Header('geoLocation') String geoLocation);

  @Post(path: '/acquire/hmac')
  Future<Response> obtainMarker(
    @Body() RequestObtainMarker request,
    @Header('geoLocation') String geoLocation,
  );
}
