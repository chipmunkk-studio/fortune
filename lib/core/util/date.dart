import 'package:easy_localization/easy_localization.dart';

abstract class FortuneDateExtension {
  static String diffTimeStamp(String timestamp) {
    var now = DateTime.now();
    var date = DateTime.parse(timestamp);
    var diff = now.difference(date);
    var time = '';

    final days = diff.inDays;
    final hours = diff.inHours;
    final minutes = diff.inMinutes;
    final seconds = diff.inSeconds;

    if (days > 7) {
      time = '${(days / 7).floor()}주 전';
    } else if (days > 0 && days < 7) {
      if (days == 1) {
        time = '하루 전';
      } else {
        time = '$days일 전';
      }
    } else if (hours > 0) {
      time = '$hours시간 전';
    } else if (minutes > 0) {
      time = '$minutes분 전';
    } else if (seconds > 0) {
      time = '$seconds초 전';
    }
    return time;
  }
}
