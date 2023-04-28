import 'package:chopper/chopper.dart';
import 'package:foresh_flutter/core/network/api/request/request_main.dart';
import 'package:foresh_flutter/core/network/api/request/request_post_marker.dart';

part 'main_service.chopper.dart';

@ChopperApi(baseUrl: "/v1/main/")
abstract class MainService extends ChopperService {
  static MainService create([ChopperClient? client]) => _$MainService(client);

  // 메인.
  @Post()
  Future<Response> main(@Body() RequestMain request);

  // 마커 획득.
  @Put(path: "marker")
  Future<Response> putMarker(@Body() RequestPostMarker request);

  // 히스토리 목록.
  @Get(path: "histories")
  Future<Response> histories();
}
