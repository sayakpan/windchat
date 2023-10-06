import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:windchat/main.dart';

class ChatUserCard extends StatefulWidget {
  const ChatUserCard({super.key});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: mq.width * .05, vertical: 5),
      elevation: 2,
      child: InkWell(
        onTap: () {},
        child: const ListTile(
          leading: CircleAvatar(
            child: Icon(CupertinoIcons.person),
          ),
          title: Text("Akash Sana"),
          subtitle: Text("Subtitle"),
          trailing: Text("12:00 PM"),
        ),
      ),
    );
  }
}
