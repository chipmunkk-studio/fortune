import 'package:fortune/di.dart';
import 'package:logger/logger.dart';

abstract class FortuneLogger {
  static void debug(String? message, {String? tag}) => serviceLocator<AppLogger>().debugPrint(tag, message);

  static void info(String? message, {String? tag}) => serviceLocator<AppLogger>().infoPrint(tag, message);

  static void error({
    String? code,
    String? message,
    String? description,
  }) =>
      serviceLocator<AppLogger>().errorPrint(code, message, description);
}

class AppLogger {
  final Logger logger;

  AppLogger(this.logger);

  debugPrint(String? tag, String? message) {
    logger.d("${tag ?? ''} >> $message");
  }

  errorPrint(
    String? code,
    String? message,
    String? description,
  ) {
    logger.e("code:$code, message:$message, description:$description");
  }

  infoPrint(String? tag, String? message) {
    logger.i("${tag ?? ''} >> $message");
  }
}
