import 'package:flutter/material.dart';
import 'package:windchat/main.dart';

class Dialogs {
  static void showSnackBar(BuildContext context, String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        msg,
        style: const TextStyle(fontSize: 16),
      ),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
    ));
  }

  static void showProgressBar(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => const Center(
              child: CircularProgressIndicator(),
            ));
  }

  static void showAlertBox(
      BuildContext context, String msg, Color color, IconData icon) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              contentPadding: const EdgeInsets.only(
                  left: 24, right: 24, top: 20, bottom: 5),
              content: Column(children: [
                Icon(
                  icon,
                  size: 50,
                  color: color,
                ),
                Text(
                  msg,
                  style: const TextStyle(fontSize: 17),
                )
              ]),
              actions: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        minimumSize: Size(
                          mq.width * .2,
                          mq.height * .05,
                        )),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: const Text("OK"))
              ],
            ));
  }
}
