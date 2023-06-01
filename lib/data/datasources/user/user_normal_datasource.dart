import 'package:foresh_flutter/core/network/api/fortune_response.dart';
import 'package:foresh_flutter/core/network/api/request/request_nickname_check.dart';
import 'package:foresh_flutter/data/responses/country/country_code_list_response.dart';
import 'package:foresh_flutter/data/responses/user/terms_response.dart';
import 'package:foresh_flutter/domain/entities/user/terms_entity.dart';

import '../../../core/network/api/service/normal/normal_user_service.dart';
import '../../../domain/entities/country_code_entity.dart';

abstract class UserNormalDataSource {
  Future<CountryCodeListEntity> getCountryCode();

  Future<void> checkNickname(RequestNicknameCheck request);

  Future<TermsEntity> getTerms(String phoneNumber);
}

class UserNormalRemoteDataSourceImpl extends UserNormalDataSource {
  final NormalUserService normalService;

  UserNormalRemoteDataSourceImpl(this.normalService);

  @override
  Future<CountryCodeListEntity> getCountryCode() async {
    final countryCode = await normalService.countryCode().then((value) => value.toResponseData());
    final countryCodeEntity = CountryCodeListResponse.fromJson(countryCode);
    return countryCodeEntity;
  }

  @override
  Future<void> checkNickname(RequestNicknameCheck request) async {
    await normalService.checkNickName(request).then((value) => value.toResponseData());
  }

  @override
  Future<TermsEntity> getTerms(String phoneNumber) async {
    final response = await normalService.terms(phoneNumber: phoneNumber).then((value) => value.toResponseData());
    final termsEntity = response != null ? TermsResponse.fromJson(response) : TermsEntity(terms: List.empty());
    return termsEntity;
  }
}
