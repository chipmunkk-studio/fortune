import 'package:foresh_flutter/core/network/api/fortune_response.dart';
import 'package:foresh_flutter/core/network/api/request/request_confirm_sms_verify_code.dart';
import 'package:foresh_flutter/core/network/api/request/request_sms_verify_code.dart';
import 'package:foresh_flutter/data/datasources/user/auth_normal_datasource.dart';
import 'package:foresh_flutter/domain/entities/sms_verify_result_entity.dart';
import 'package:foresh_flutter/domain/usecases/obtain_sms_verify_code.dart';

import '../../../../../core/util/usecase.dart';
import '../../../domain/usecases/sms_verify_code_confirm_usecase.dart';
import '../../core/error/fortune_error_mapper.dart';
import '../../domain/repositories/auth_normal_remote_repository.dart';

class AuthNormalRepositoryImpl implements AuthNormalRemoteRepository {
  final AuthNormalDataSource authDataSource;
  final FortuneErrorMapper errorMapper;

  AuthNormalRepositoryImpl({
    required this.authDataSource,
    required this.errorMapper,
  });

  @override
  Future<FortuneResult<void>> requestSmsVerifyCode(RequestSmsVerifyCodeParams params) async {
    final remoteData = await authDataSource
        .requestSmsVerifyCode(
          RequestSmsVerifyCode(
            phoneNumber: params.phoneNumber,
            countryCode: params.countryCode,
          ),
        )
        .toRemoteDomainData(errorMapper);
    return remoteData;
  }

  @override
  Future<FortuneResult<SmsVerifyCodeConfirmEntity>> confirmSmsVerifyCode(
    RequestConfirmSmsVerifyCodeParams params,
  ) async {
    final remoteData = await authDataSource
        .confirmSmsVerifyCode(
          RequestConfirmSmsVerifyCode(
            phoneNumber: params.phoneNumber,
            countryCode: params.countryCode,
            authenticationNumber: params.authenticationNumber,
            pushToken: params.pushToken,
          ),
        )
        .toRemoteDomainData(errorMapper);
    return remoteData;
  }
}
