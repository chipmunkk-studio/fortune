import 'package:easy_localization/easy_localization.dart';
import 'package:fortune/core/message_ext.dart';

abstract class FortuneDateExtension {
  static String convertTimeAgo(String? timestamp) {
    if (timestamp == null) {
      return FortuneTr.msgJustNow();
    }
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

  static bool isDaysPassed(
    String? serverTime, {
    required int passDay,
  }) {
    final time = serverTime;
    if (time != null) {
      DateTime serverTime = DateTime.parse(time);
      DateTime currentTime = DateTime.now();
      Duration duration = currentTime.difference(serverTime);
      return duration.inDays >= passDay;
    } else {
      return true;
    }
  }

  static bool isDeadlinePassed(String? deadline) {
    if (deadline == null || deadline.isEmpty) {
      return true;
    }

    DateTime? deadlineDate = DateTime.parse(deadline);
    DateTime currentDate = DateTime.now();

    return currentDate.isAfter(deadlineDate);
  }

  static String getDaysUntilDeadline(String? deadline) {
    if (deadline == null || deadline.isEmpty) {
      return 'D-99';
    }

    DateTime? endTime = DateTime.parse(deadline);
    DateTime currentTime = DateTime.now();

    int difference = endTime.difference(currentTime).inDays;

    return 'D-$difference';
  }

  // ISO 8601 문자열에서 DateTime?로 변환
  static DateTime? dateTimeFromIso8601String(String? date) => date == null ? null : DateTime.tryParse(date);

  // DateTime?에서 ISO 8601 문자열로 변환
  static String? dateTimeToIso8601String(DateTime? date) => date?.toIso8601String();
}


