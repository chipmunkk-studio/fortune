import 'package:easy_localization/easy_localization.dart';

abstract class FortuneErrorDataReference {
  static const common = 'common';

  static const errorClientInternal = 'errorClientInternal';
  static const errorClientUnknown = 'errorClientUnknown';
  static const errorClientAuth = 'errorClientAuth';
}

String? getErrorDataMessage(int? errorCode, String? errorType, String? errorMessage) {
  // 클라이언트 에러메시지 > 서버 에러메시지 > 기본 에러메세지, 순서로 메세지가 출력됨.
  var convertedMessage = errorType?.tr(gender: errorCode.toString()) ?? errorMessage;
  // tr()에서 null 처리가 안되서 메세지 포함여부로 판단해야함.
  if (convertedMessage != null && errorType != null && convertedMessage.contains(errorType)) {
    return errorMessage ?? errorType.tr(gender: FortuneErrorDataReference.common);
  } else {
    return convertedMessage;
  }
}
