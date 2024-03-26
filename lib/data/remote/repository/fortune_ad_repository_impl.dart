import 'package:fortune/data/error/fortune_error_mapper.dart';
import 'package:fortune/data/remote/api/fortune_response.dart';
import 'package:fortune/data/remote/datasource/fortune_ad_datasource.dart';
import 'package:fortune/data/remote/request/request_show_ad_complete.dart';
import 'package:fortune/domain/entity/fortune_user_entity.dart';
import 'package:fortune/domain/repository/fortune_ad_repository.dart';

class FortuneAdRepositoryImpl implements FortuneAdRepository {
  final FortuneAdDataSource fortuneAdDataSource;
  final FortuneErrorMapper errorMapper;

  FortuneAdRepositoryImpl({
    required this.fortuneAdDataSource,
    required this.errorMapper,
  });

  @override
  Future<FortuneUserEntity> onShowAdComplete(int ts) async {
    try {
      final remoteData = await fortuneAdDataSource
          .onShowAdComplete(
            RequestShowAdComplete(
              ts: ts,
            ),
          )
          .toRemoteDomainData(errorMapper);
      return remoteData;
    } catch (e) {
      rethrow;
    }
  }
}
