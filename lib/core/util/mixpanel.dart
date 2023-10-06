import 'package:flutter/foundation.dart';
import 'package:fortune/di.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';

class MixpanelTracker {
  Mixpanel? _mixpanel;

  Mixpanel? get mixpanel {
    if (kIsWeb) {
      return null;
    }

    _mixpanel ??= serviceLocator<Mixpanel>();
    return _mixpanel;
  }

  void trackEvent(
    String eventName, {
    Map<String, dynamic>? properties,
  }) {
    // 리얼에서만 로깅함.
    if (kReleaseMode) {
      _mixpanel?.track(eventName, properties: properties);
    }
  }
}
