import 'package:flutter/material.dart';
import 'package:windchat/api/api.dart';
import 'package:windchat/main.dart';
import 'package:windchat/models/messages.dart';

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
    return API.user.uid == widget.message.fromID
        ? _senderMessage()
        : _receiverMessage();
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
                  padding: EdgeInsets.all(mq.width * .03),
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 156, 238, 159),
                      border: Border.all(
                          color: const Color.fromARGB(255, 81, 201, 87)),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(5),
                      )),
                  child: Text(
                    widget.message.msg,
                    style: const TextStyle(fontSize: 17),
                  )),
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
                  MyDateUtility.getFormattedTime(
                      context: context, time: widget.message.sent),
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
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
              style: const TextStyle(fontSize: 14, color: Colors.black54),
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
                  padding: EdgeInsets.all(mq.width * .03),
                  decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      border: Border.all(color: Colors.blue.shade300),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                      )),
                  child: Text(
                    widget.message.msg,
                    style: const TextStyle(fontSize: 17),
                  )),
            ),
          ],
        ),
      ],
    );
  }
}
