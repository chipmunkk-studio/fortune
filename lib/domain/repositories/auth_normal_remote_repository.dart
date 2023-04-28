import 'package:foresh_flutter/domain/entities/sms_verify_result_entity.dart';
import 'package:foresh_flutter/domain/usecases/obtain_sms_verify_code.dart';

import '../../../../core/util/usecase.dart';
import '../usecases/sms_verify_code_confirm_usecase.dart';

abstract class AuthNormalRemoteRepository {
  Future<FortuneResult<void>> requestSmsVerifyCode(RequestSmsVerifyCodeParams params);

  Future<FortuneResult<SmsVerifyCodeConfirmEntity>> confirmSmsVerifyCode(RequestConfirmSmsVerifyCodeParams params);
}