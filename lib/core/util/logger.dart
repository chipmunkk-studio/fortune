import 'package:foresh_flutter/di.dart';
import 'package:logger/logger.dart';

abstract class FortuneLogger {
  static void debug(String? message, {String? tag}) => serviceLocator<AppLogger>().debugPrint(tag, message);

  static void error(String? message, {String? tag}) => serviceLocator<AppLogger>().errorPrint(tag, message);
}

class AppLogger {
  final Logger logger;

  AppLogger(this.logger);

  debugPrint(String? tag, String? message) {
    logger.d("${tag ?? ''} >> $message");
  }

  errorPrint(String? tag, String? message) {
    logger.e("${tag ?? ''}>> $message");
  }
}
