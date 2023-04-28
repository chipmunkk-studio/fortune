import 'package:foresh_flutter/core/network/api/fortune_response.dart';
import 'package:foresh_flutter/core/network/api/request/request_nickname_check.dart';
import 'package:foresh_flutter/core/network/api/request/request_sign_up.dart';
import 'package:foresh_flutter/data/responses/country/country_code_list_response.dart';
import 'package:foresh_flutter/domain/entities/token_entity.dart';

import '../../../core/network/api/service/normal/normal_user_service.dart';
import '../../../domain/entities/country_code_entity.dart';

abstract class UserNormalDataSource {
  Future<CountryCodeListEntity> getCountryCode();

  Future<void> checkNickname(RequestNicknameCheck request);

  Future<TokenEntity> signUp(RequestSignUp request);
}

class UserNormalRemoteDataSourceImpl extends UserNormalDataSource {
  final NormalUserService memberNormalService;

  UserNormalRemoteDataSourceImpl(this.memberNormalService);

  @override
  Future<CountryCodeListEntity> getCountryCode() async {
    final countryCode = await memberNormalService.countryCode().then((value) => value.toResponseData());
    final countryCodeEntity = CountryCodeListResponse.fromJson(countryCode);
    return countryCodeEntity;
  }

  @override
  Future<void> checkNickname(RequestNicknameCheck request) async {
    await memberNormalService.checkNickName(request).then((value) => value.toResponseData());
  }

  @override
  Future<TokenEntity> signUp(RequestSignUp request) async {
    final tokenResponse = await memberNormalService
        .signUp(
          phoneNumber: request.data.phoneNumber,
          countryCode: request.data.countryCode,
          nickname: request.data.nickname,
          profileImage: request.profileImage,
        )
        .then((value) => value.toResponseData());
    final tokenEntity = TokenEntity.fromJson(tokenResponse);
    return tokenEntity;
  }
}
