import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

getCurrentCountryCode() {
  final Locale currentLocale = PlatformDispatcher.instance.locale;
  return currentLocale.countryCode;
}
