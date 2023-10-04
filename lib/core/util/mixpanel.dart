import 'package:flutter/foundation.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';

extension Tracker on Mixpanel {
  void trackEvent(
    String eventName, {
    Map<String, dynamic>? properties,
  }) {
    // 리얼에서만 로깅함.
    if (kReleaseMode) {
      track(eventName, properties: properties);
    }
  }
}
