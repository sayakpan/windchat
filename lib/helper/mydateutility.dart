import 'package:flutter/material.dart';

class MyDateUtility {
  static String getFormattedTime(
      {required BuildContext context, required String time}) {
    final datetime = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    return TimeOfDay.fromDateTime(datetime).format(context);
  }
}
