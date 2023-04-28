import 'package:foresh_flutter/core/network/api/fortune_response.dart';
import 'package:foresh_flutter/data/datasources/local_datasource.dart';

import '../../core/error/fortune_error_mapper.dart';
import '../../core/util/usecase.dart';
import '../../domain/repositories/local_repository.dart';

class LocalRepositoryImpl implements LocalRepository {
  final LocalDataSource dataSource;
  final FortuneErrorMapper errorMapper;

  LocalRepositoryImpl({
    required this.dataSource,
    required this.errorMapper,
  });

  @override
  Future<FortuneResult<bool>> getIsShowWelcomeScreen() async {
    final localData = await dataSource.getIsShowWelcomeScreen().toLocalDomainData(errorMapper);
    return localData;
  }

  @override
  Future<FortuneResult<void>> setIsShowWelcomeScreen(bool isShow) async {
    final localData = await dataSource.setIsShowWelcomeScreen(isShow).toLocalDomainData(errorMapper);
    return localData;
  }
}
