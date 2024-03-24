import 'package:fortune/data/error/fortune_error_mapper.dart';
import 'package:fortune/data/remote/api/fortune_response.dart';
import 'package:fortune/data/remote/datasource/fortune_user_datasource.dart';
import 'package:fortune/domain/entity/fortune_user_entity.dart';
import 'package:fortune/domain/repository/fortune_user_repository.dart';

class FortuneUserRepositoryImpl implements FortuneUserRepository {
  final FortuneUserDataSource fortuneUserDataSource;
  final FortuneErrorMapper errorMapper;

  FortuneUserRepositoryImpl({
    required this.fortuneUserDataSource,
    required this.errorMapper,
  });

  @override
  Future<FortuneUserEntity> me() async {
    try {
      final remoteData = await fortuneUserDataSource.me().toRemoteDomainData(errorMapper);
      return remoteData;
    } catch (e) {
      rethrow;
    }
  }
}
