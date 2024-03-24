import 'package:fortune/data/remote/api/fortune_response.dart';
import 'package:fortune/data/remote/api/service/fortune_user_service.dart';
import 'package:fortune/data/remote/response/fortune_user_response.dart';
import 'package:fortune/domain/entity/fortune_user_entity.dart';

abstract class FortuneUserDataSource {
  Future<FortuneUserEntity> me();
}

class FortuneUserDataSourceImpl extends FortuneUserDataSource {
  final FortuneUserService fortuneUserService;

  FortuneUserDataSourceImpl({
    required this.fortuneUserService,
  });

  @override
  Future<FortuneUserEntity> me() async {
    return await fortuneUserService.me().then(
          (value) => FortuneUserResponse.fromJson(
            value.toResponseData(),
          ),
        );
  }
}
