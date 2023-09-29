import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

getLocaleContent({
  required String en,
  required String kr,
}) {
  final Locale currentLocale = PlatformDispatcher.instance.locale;
  switch (currentLocale.countryCode) {
    case 'KR':
      return kr;
    case 'US':
      return en;
    default:
      return en;
  }
}
