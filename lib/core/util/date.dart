import 'package:easy_localization/easy_localization.dart';
import 'package:fortune/core/message_ext.dart';

abstract class FortuneDateExtension {
  static String convertTimeAgo(String timestamp) {
    DateTime dateTime = DateTime.parse(timestamp);
    DateTime now = DateTime.now();
    Duration timeDifference = now.difference(dateTime);

    if (timeDifference.inDays > 0) {
      return FortuneTr.msgDaysAgo(timeDifference.inDays.toString());
    } else if (timeDifference.inHours > 0) {
      return FortuneTr.msgHoursAgo(timeDifference.inHours.toString());
    } else if (timeDifference.inMinutes > 0) {
      return FortuneTr.msgMinutesAgo(timeDifference.inMinutes.toString());
    } else {
      return FortuneTr.msgJustNow();
    }
  }

  static String formattedDate(
    String? time, {
    String format = 'yyyy.MM.dd',
  }) {
    if (time != null) {
      DateTime parsedDate = DateTime.parse(time);
      return DateFormat(format).format(parsedDate);
    } else {
      return '';
    }
  }

  static bool isTwoWeeksPassed(
    String? time,
  ) {
    if (time != null) {
      DateTime serverTime = DateTime.parse(time);
      DateTime currentTime = DateTime.now();
      Duration duration = currentTime.difference(serverTime);
      return duration.inDays >= 14;
    } else {
      return true;
    }
  }
}
