import 'package:flutter/foundation.dart';
import 'package:fortune/presentation-web/fortune_web_ext.dart';

class FortuneWebViewArgs {
  final String url;

  FortuneWebViewArgs({
    this.url = kReleaseMode ? FortuneWebExtension.webMainUrl : FortuneWebExtension.webMainDebugUrl,
  });
}
