// import 'package:chopper/chopper.dart';
//
// import '../request/request_reward_exchange.dart';
//
// part 'mission_service.chopper.dart';
//
// @ChopperApi(baseUrl: "/v1/mission/")
// abstract class MissionService extends ChopperService {
//   static MissionService create([ChopperClient? client]) => _$MissionService(client);
//
//   // 리워드 상품 목록 조회.
//   @Get()
//   Future<Response> missions({
//     @Query('offset') int page = 0,
//     @Query('limit') int limit = 10,
//   });
//
//   // 리워드 상품 상세 조회.
//   @Get(path: "{id}")
//   Future<Response> missionDetail(
//     @Path('id') int id,
//   );
//
//   // 리워드 상품 신청.
//   @Post(path: "exchange")
//   Future<Response> missionClear(
//     @Body() RequestRewardExchange request,
//   );
// }
