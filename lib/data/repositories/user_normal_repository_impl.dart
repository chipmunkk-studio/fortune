import 'package:foresh_flutter/core/network/api/fortune_response.dart';
import 'package:foresh_flutter/data/datasources/user/user_normal_datasource.dart';
import 'package:foresh_flutter/domain/entities/token_entity.dart';
import 'package:foresh_flutter/domain/usecases/sign_up_usecase.dart';

import '../../../../core/util/usecase.dart';
import '../../core/error/fortune_error_mapper.dart';
import '../../core/network/api/request/request_nickname_check.dart';
import '../../core/network/api/request/request_sign_up.dart';
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

  @override
  Future<FortuneResult<TokenEntity>> signUp(RequestSignUpParams param) async{
    final remoteData = await userDataSource
        .signUp(
          RequestSignUp(
            data: param.data,
            profileImage: param.profileImage,
          ),
        )
        .toRemoteDomainData(errorMapper);
    return remoteData;
  }
}
