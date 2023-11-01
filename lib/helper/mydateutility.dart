import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyDateUtility {
  static String getFormattedTime(
      {required BuildContext context, required String time}) {
    final DateTime datetime =
        DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    return TimeOfDay.fromDateTime(datetime).format(context);
  }

  static String getFormattedDateTime(
      {required BuildContext context, required String time}) {
    final DateTime datetime =
        DateTime.fromMillisecondsSinceEpoch(int.parse(time));

    String formattedDate = DateFormat('dd MMM yyyy').format(datetime);

    String formattedTime = DateFormat.jm().format(datetime);
    return "$formattedDate, $formattedTime";
  }

  //get formatted last active time of user in chat screen
  static String getLastActiveTime(
      {required BuildContext context, required String lastActive}) {
    final int i = int.tryParse(lastActive) ?? -1;

    //if time is not available then return below statement
    if (i == -1) return 'Last seen not available';

    DateTime time = DateTime.fromMillisecondsSinceEpoch(i);
    DateTime now = DateTime.now();

    String formattedTime = TimeOfDay.fromDateTime(time).format(context);
    if (time.day == now.day &&
        time.month == now.month &&
        time.year == time.year) {
      return 'Last seen today at $formattedTime';
    }

    if ((now.difference(time).inHours / 24).round() == 1) {
      return 'Last seen yesterday at $formattedTime';
    }

    String month = _getMonth(time);

    return 'Last seen on ${time.day} $month on $formattedTime';
  }

  // get month name from month no. or index
  static String _getMonth(DateTime date) {
    switch (date.month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sept';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
    }
    return 'NA';
  }
}
