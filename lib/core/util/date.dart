import 'package:easy_localization/easy_localization.dart';

abstract class FortuneDateExtension {
  static String convertTimeAgo(String timestamp) {
    DateTime dateTime = DateTime.parse(timestamp);
    DateTime now = DateTime.now();
    Duration timeDifference = now.difference(dateTime);

    if (timeDifference.inDays > 0) {
      return "${timeDifference.inDays}일 전";
    } else if (timeDifference.inHours > 0) {
      return "${timeDifference.inHours}시간 전";
    } else if (timeDifference.inMinutes > 0) {
      return "${timeDifference.inMinutes}분 전";
    } else {
      return "방금 전";
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
}
