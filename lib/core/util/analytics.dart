import 'package:firebase_analytics/firebase_analytics.dart';

class FortuneAnalytics {
  final FirebaseAnalytics analytics;

  FortuneAnalytics(this.analytics);

  Future<void> sendCustomEventWithParams({
    required String tag,
    Map<String, dynamic>? data,
  }) async {
    await analytics.logEvent(
      name: tag,
      parameters: data,
    );
  }

  Future<void> sendScreenView({
    required String screenName,
  }) async {
    await analytics.setCurrentScreen(
      screenName: screenName,
    );
  }

  /// 표준 select_content 이벤트 로그를 발생시킨다.
  /// 유저가 특정 카테고리(contentType)의 아이템들 중 어떤 아이템(temId)을 선택했는지를 알려준다.
// Future<void> sendSelectContent({
//   required String contentType,
//   required String itemId,
// }) async {
//   await analytics.logSelectContent(
//     contentType: contentType,
//     itemId: itemId,
//   );
// }
}
