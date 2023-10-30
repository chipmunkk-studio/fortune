import 'package:mixpanel_flutter/mixpanel_flutter.dart';

class MixpanelTracker {
  Mixpanel? _mixpanel;

  MixpanelTracker(this._mixpanel);

  factory MixpanelTracker.init(Mixpanel? mixpanel) {
    return MixpanelTracker(mixpanel);
  }

  void trackEvent(
    String eventName, {
    Map<String, dynamic>? properties,
  }) {
    _mixpanel?.track(eventName, properties: properties);
  }
}
