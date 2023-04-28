import 'package:alt_sms_autofill/alt_sms_autofill.dart';
import 'package:dartz/dartz.dart';
import 'package:foresh_flutter/core/util/logger.dart';
import 'package:permission_handler/permission_handler.dart';

class FortunePermissionUtil {
  /// 권한 요청.
  /// - 모든 권한을 한꺼번에 요청하고, 하나라도 거부될 경우 false를 리턴 함.
  Future<bool> requestPermission(List<Permission> permissions) async {
    bool isGranted = true;
    Map<Permission, PermissionStatus> statuses = await permissions.request();
    statuses.forEach((key, value) {
      if (!value.isGranted) {
        isGranted = false;
      }
    });
    return isGranted;
  }

  startSmsListening(Function1 onReceive) async {
    FortuneLogger.debug("_startSmsListening()");
    String? comingSms = await AltSmsAutofill().listenForSms;
    if (comingSms != null) {
      String verifyCode = _getVerifyCode(comingSms);
      FortuneLogger.debug("인증번호: $verifyCode");
      if (verifyCode.length >= 4) {
        onReceive(verifyCode);
      }
    }
  }

  _getVerifyCode(String? sms) {
    final intRegex = RegExp(r'\d+', multiLine: true);
    if (sms != null) {
      return intRegex.allMatches(sms).first.group(0);
    } else {
      return "";
    }
  }
}
