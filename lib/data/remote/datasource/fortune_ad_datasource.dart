import 'package:fortune/data/remote/api/fortune_response.dart';
import 'package:fortune/data/remote/api/service/fortune_ad_service.dart';
import 'package:fortune/data/remote/api/service/marker_service.dart';
import 'package:fortune/data/remote/request/request_obtain_marker.dart';
import 'package:fortune/data/remote/request/request_show_ad_complete.dart';
import 'package:fortune/data/remote/response/fortune_user_response.dart';
import 'package:fortune/data/remote/response/marker_list_response.dart';
import 'package:fortune/data/remote/response/marker_obtain_response.dart';
import 'package:fortune/domain/entity/fortune_user_entity.dart';
import 'package:fortune/domain/entity/marker_list_entity.dart';
import 'package:fortune/domain/entity/marker_obtain_entity.dart';

abstract class FortuneAdDataSource {
  Future<FortuneUserEntity> onShowAdComplete(RequestShowAdComplete request);
}

class FortuneAdDataSourceImpl extends FortuneAdDataSource {
  final FortuneAdService fortuneAdService;

  FortuneAdDataSourceImpl({
    required this.fortuneAdService,
  });

  @override
  Future<FortuneUserEntity> onShowAdComplete(RequestShowAdComplete request) async {
    return await fortuneAdService.onShowAdComplete(request).then(
          (value) => FortuneUserResponse.fromJson(
            value.toResponseData(),
          ),
        );
  }
}
