import 'package:flutter/material.dart';
import 'package:windchat/main.dart';
import 'package:windchat/models/chat_user.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;

  const ChatUserCard({super.key, required this.user});

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
        child: ListTile(
          // Profile image
          leading: CircleAvatar(
            radius: 25.0,
            child: ClipOval(
              child: Image.network(
                widget.user.image,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // leading: ClipRRect(
          //     borderRadius: BorderRadius.circular(mq.height * .03),
          //     child: CachedNetworkImage(
          //       width: mq.height * .055,
          //       height: mq.height * .055,
          //       imageUrl: widget.user.image,
          //       errorWidget: (context, url, error) =>
          //           const CircleAvatar(child: Icon(CupertinoIcons.person)),
          //     )),

          // User Name
          title: Text(widget.user.name),

          // About
          subtitle: Text(widget.user.about),

          // Last Active
          // trailing: Text(widget.user.lastActive),

          // Last Active
          trailing: Container(
            width: 15,
            height: 15,
            decoration: BoxDecoration(
                color: Colors.greenAccent.shade400,
                borderRadius: BorderRadius.circular(9)),
          ),
        ),
      ),
    );
  }
}
