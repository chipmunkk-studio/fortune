import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

isLocaleKorean() {
  final Locale currentLocale = PlatformDispatcher.instance.locale;
  return currentLocale.countryCode == 'KR';
}

getCountryNameByLocale({
  String? enName,
  String? krName,
  String? iso2,
}) {
  final Locale currentLocale = PlatformDispatcher.instance.locale;
  switch (currentLocale.countryCode) {
    case 'KR':
      return krName;
    case 'US':
      return enName;
    default:
      return enName;
  }
}
