import 'package:foresh_flutter/core/network/api/fortune_response.dart';
import 'package:foresh_flutter/data/datasources/user/user_normal_datasource.dart';

import '../../../../core/util/usecase.dart';
import '../../core/error/fortune_error_mapper.dart';
import '../../core/network/api/request/request_nickname_check.dart';
import '../../domain/entities/country_code_entity.dart';
import '../../domain/repositories/user_normal_remote_repository.dart';
import '../../domain/usecases/check_nickname_usecase.dart';

class UserNormalRepositoryImpl implements UserNormalRemoteRepository {
  final UserNormalDataSource userDataSource;
  final FortuneErrorMapper errorMapper;

  UserNormalRepositoryImpl({
    required this.userDataSource,
    required this.errorMapper,
  });

  @override
  Future<FortuneResult<CountryCodeListEntity>> getCountryCode() async {
    final remoteData = await userDataSource.getCountryCode().toRemoteDomainData(errorMapper);
    return remoteData;
  }

  @override
  Future<FortuneResult<void>> checkNickname(RequestCheckNickNameParams params) async {
    final remoteData = await userDataSource
        .checkNickname(
          RequestNicknameCheck(
            nickname: params.nickname,
          ),
        )
        .toRemoteDomainData(errorMapper);
    return remoteData;
  }
}
