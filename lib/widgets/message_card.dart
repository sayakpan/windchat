import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:windchat/api/api.dart';
import 'package:windchat/helper/custom_chat_theme.dart';
import 'package:windchat/helper/dialogs.dart';
import 'package:windchat/main.dart';
import 'package:windchat/models/messages.dart';
import 'package:windchat/screens/auth/pref.dart';
import 'package:windchat/widgets/custom_widgets.dart';

import '../helper/mydateutility.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message});
  final Messages message;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    bool isMyMessage = API.user.uid == widget.message.fromID;
    return InkWell(
      onLongPress: () {
        _showMessageOptionBottomSheet(isMyMessage);
      },
      child: isMyMessage ? _senderMessage() : _receiverMessage(),
    );
  }

  // Widget for Sender Message Box
  Widget _senderMessage() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Message Box
            Flexible(
              child: Container(
                  margin: EdgeInsets.only(
                    left: mq.width * 0.2,
                    right: mq.width * 0.04,
                    top: mq.height * .01,
                    bottom: mq.height * .01,
                  ),
                  padding: EdgeInsets.all(widget.message.type == "text"
                      ? mq.width * .03
                      : mq.width * .02),
                  decoration: BoxDecoration(
                      gradient: CustomTheme.customTheme(
                          'sender', Pref.gradientIndexForMsg),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(5),
                      )),
                  child: widget.message.type == "text"
                      ? Text(
                          widget.message.msg,
                          style: const TextStyle(
                              fontSize: 17, color: Colors.white),
                        )
                      : _imageMessage(widget.message.msg, Colors.white)),
            ),
          ],
        ),

        // Show Message Time and Status
        Padding(
          padding: EdgeInsets.only(right: mq.width * .04),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              //Read Message Blue Tick
              if (widget.message.read.isEmpty)
                const Icon(
                  Icons.done,
                  color: Colors.grey,
                )
              else
                const Icon(
                  Icons.done_all_sharp,
                  color: Colors.blue,
                ),
              Padding(
                padding: EdgeInsets.only(left: mq.width * .01),
                child: Text(
                  MyDateUtility.getMessageTime(
                      context: context, time: widget.message.sent),
                  style: TextStyle(
                      fontSize: 14, color: Theme.of(context).primaryColorDark),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Widget for Receiver Message Box
  Widget _receiverMessage() {
    // Update the Read Status of the received message
    if (widget.message.read.isEmpty) {
      API.setMessageReadStatus(widget.message);
    }

    return Column(
      children: [
        // Show Message Time
        Padding(
          padding: EdgeInsets.only(left: mq.width * 0.04),
          child: Row(children: [
            Text(
              MyDateUtility.getFormattedTime(
                  context: context, time: widget.message.sent),
              style: TextStyle(
                  fontSize: 14, color: Theme.of(context).primaryColorDark),
            )
          ]),
        ),

        // Message Box
        Row(
          children: [
            Flexible(
              child: Container(
                  margin: EdgeInsets.only(
                    left: mq.width * 0.04,
                    right: mq.width * 0.2,
                    top: mq.height * .01,
                    bottom: mq.height * .01,
                  ),
                  padding: EdgeInsets.all(widget.message.type == "text"
                      ? mq.width * .03
                      : mq.width * .02),
                  decoration: BoxDecoration(
                      gradient: CustomTheme.customTheme(
                          'receiver', Pref.gradientIndexForMsg),
                      // border: Border.all(
                      //     color: const Color.fromARGB(255, 207, 207, 207)),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                      )),
                  child: widget.message.type == "text"
                      ? Text(
                          widget.message.msg,
                          style: const TextStyle(
                              fontSize: 17, color: Colors.black),
                        )
                      : _imageMessage(widget.message.msg, Colors.black)),
            ),
          ],
        ),
      ],
    );
  }

  // Widget for Image type Message Box
  Widget _imageMessage(String imageUrl, Color errortext) {
    return InkWell(
      onTap: () {
        Dialogs.showImageDialog(context, imageUrl);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: CachedNetworkImage(
            height: mq.height * .3,
            width: mq.width * .7,
            fit: BoxFit.cover,
            imageUrl: imageUrl,
            errorWidget: (context, url, error) => Row(
                  children: [
                    Icon(
                      Icons.error,
                      color: errortext,
                      size: 20,
                    ),
                    Text(
                      " Error : Image might not exists !",
                      style: TextStyle(fontSize: 15, color: errortext),
                    )
                  ],
                )),
      ),
    );
  }

  // Widget for Bottom Option Panel
  void _showMessageOptionBottomSheet(bool isMyMessage) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        builder: ((context) {
          return ListView(
            shrinkWrap: true,
            children: [
              Container(
                height: 4,
                margin: EdgeInsets.symmetric(
                    vertical: mq.height * .015, horizontal: mq.width * .4),
                decoration: BoxDecoration(
                    color: Colors.grey, borderRadius: BorderRadius.circular(8)),
              ),

              // Options according to type
              widget.message.type == "text"
                  ?
                  // Copy Text
                  OptionItem(
                      icon: const Icon(Icons.copy_all_rounded,
                          color: Colors.blue, size: 26),
                      name: 'Copy Text',
                      onTap: () async {
                        await Clipboard.setData(
                                ClipboardData(text: widget.message.msg))
                            .then((value) {
                          //for hiding bottom sheet
                          Navigator.pop(context);
                          Dialogs.showSnackBar(context, "Copied to clipboard",
                              Colors.grey.shade500);
                        });
                      })
                  :
                  // Download Image
                  OptionItem(
                      icon: const Icon(Icons.download,
                          color: Colors.blue, size: 26),
                      name: 'Download',
                      onTap: () async {
                        try {
                          logger.w('Image Url: ${widget.message.msg}');
                          await GallerySaver.saveImage(widget.message.msg,
                                  albumName: 'WindChat')
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
                      }),

              // Delete Message
              if (isMyMessage)
                OptionItem(
                    icon: const Icon(Icons.delete, color: Colors.red, size: 26),
                    name: 'Delete Message',
                    onTap: () async {
                      await API.deleteMessage(widget.message).then((value) {
                        Navigator.pop(context);
                      });
                    }),

              Divider(
                endIndent: mq.width * .04,
                indent: mq.width * .04,
              ),

              // Read Message
              if (widget.message.read.isNotEmpty)
                OptionItem(
                    icon: const Icon(Icons.done_all,
                        color: Colors.blue, size: 26),
                    name:
                        'Read :  ${MyDateUtility.getMessageDateTime(context: context, time: widget.message.read)}',
                    onTap: () async {}),

              // Delivered Message
              OptionItem(
                  icon: const Icon(Icons.done, color: Colors.grey, size: 26),
                  name:
                      'Delivered :  ${MyDateUtility.getMessageDateTime(context: context, time: widget.message.sent)}',
                  onTap: () async {}),
            ],
          );
        }));
  }
}
