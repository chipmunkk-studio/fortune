import 'package:foresh_flutter/core/network/api/fortune_response.dart';
import 'package:foresh_flutter/data/datasources/user/user_normal_datasource.dart';
import 'package:foresh_flutter/domain/entities/user/terms_entity.dart';

import '../../../../core/util/usecase.dart';
import '../../core/error/fortune_error_mapper.dart';
import '../../domain/repositories/user_normal_remote_repository.dart';

class UserNormalRepositoryImpl implements UserNormalRemoteRepository {
  final UserNormalDataSource userDataSource;
  final FortuneErrorMapper errorMapper;

  UserNormalRepositoryImpl({
    required this.userDataSource,
    required this.errorMapper,
  });

  @override
  Future<FortuneResult<TermsEntity>> getTerms(String phoneNumber) async {
    final remoteData = await userDataSource.getTerms(phoneNumber).toRemoteDomainData(errorMapper);
    return remoteData;
  }
}
