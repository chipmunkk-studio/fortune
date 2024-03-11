import 'package:chopper/chopper.dart';

part 'common_service.chopper.dart';

@ChopperApi(baseUrl: "/v1/common/")
abstract class CommonService extends ChopperService {
  static CommonService create([ChopperClient? client]) => _$CommonService(client);

  // 공지사항.
  @Get(path: 'notice')
  Future<Response> announcement({
    @Query('offset') int page = 0,
    @Query('limit') int limit = 30,
  });

  // FAQ
  @Get(path: 'faq')
  Future<Response> faq({
    @Query('offset') int page = 0,
    @Query('limit') int limit = 30,
  });
}
