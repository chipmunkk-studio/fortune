import 'package:foresh_flutter/core/network/api/fortune_response.dart';
import 'package:foresh_flutter/data/responses/user/terms_response.dart';
import 'package:foresh_flutter/domain/entities/user/terms_entity.dart';

import '../../../core/network/api/service/normal/normal_user_service.dart';

abstract class UserNormalDataSource {
  Future<TermsEntity> getTerms(String phoneNumber);
}

class UserNormalRemoteDataSourceImpl extends UserNormalDataSource {
  final NormalUserService normalService;

  UserNormalRemoteDataSourceImpl(this.normalService);

  @override
  Future<TermsEntity> getTerms(String phoneNumber) async {
    final response = await normalService.terms(phoneNumber: phoneNumber).then((value) => value.toResponseData());
    final termsEntity = response != null ? TermsResponse.fromJson(response) : TermsEntity(terms: List.empty());
    return termsEntity;
  }
}
