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
}
