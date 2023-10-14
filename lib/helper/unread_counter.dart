import 'package:flutter/material.dart';
import 'package:windchat/models/chat_user.dart';
import '../api/api.dart';
import '../models/messages.dart';

// ignore: must_be_immutable
class UnreadCounter extends StatefulWidget {
  final ChatUser user;
  final TextStyle numberstyle;

  const UnreadCounter(
      {super.key, required this.user, required this.numberstyle});

  @override
  State<UnreadCounter> createState() => _UnreadCounterState();
}

class _UnreadCounterState extends State<UnreadCounter> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: API.getAllMessages(widget.user),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Text('', style: widget.numberstyle);
            case ConnectionState.active:
            case ConnectionState.done:
              final data = snapshot.data?.docs;
              final unreadMessages = data!
                  .map((element) => Messages.fromJson(element.data()))
                  .where((element) =>
                      element.read.isEmpty == true &&
                      element.fromID != API.user.uid)
                  .toList();
              return Text('${unreadMessages.length}',
                  style: widget.numberstyle);
          }
        });
  }
}
