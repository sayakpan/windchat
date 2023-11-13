import 'package:flutter/material.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:windchat/main.dart';

class Dialogs {
  static void showSnackBar(BuildContext context, String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      content: Text(
        msg,
        style: const TextStyle(fontSize: 16),
      ),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
    ));
  }

  static void showImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SizedBox(
            width: double.maxFinite,
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Close',
                style: TextStyle(fontSize: 18),
              ),
            ),
            TextButton(
              onPressed: () async {
                try {
                  logger.w('Image Url: $imageUrl');
                  await GallerySaver.saveImage(imageUrl, albumName: 'WindChat')
                      .then((success) {
                    //for hiding bottom sheet
                    Navigator.pop(context);

                    if (success != null && success) {
                      Dialogs.showSnackBar(
                          context, 'Saved in gallery', Colors.green);
                    } else {
                      Dialogs.showSnackBar(
                          context, 'Downloading Failed', Colors.red);
                    }
                  });
                } catch (e) {
                  logger.w('ErrorWhileSavingImg: $e');
                }
              },
              child: const Text('Download', style: TextStyle(fontSize: 18)),
            ),
          ],
        );
      },
    );
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
