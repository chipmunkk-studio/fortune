

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
}
