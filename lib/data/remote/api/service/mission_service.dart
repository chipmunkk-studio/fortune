import 'package:chopper/chopper.dart';
import 'package:fortune/data/remote/request/request_mission_acquire.dart';

part 'mission_service.chopper.dart';

@ChopperApi(baseUrl: "api/v1/missions")
abstract class MissionService extends ChopperService {
  static MissionService create([ChopperClient? client]) => _$MissionService(client);

  @Get()
  Future<Response> missions();

  @Get(path: "/{id}")
  Future<Response> missionDetail(
    @Path('id') String id,
  );

  @Post(path: "/acquire/hmac")
  Future<Response> missionAcquire(
    @Body() RequestMissionAcquire request,
  );
}
