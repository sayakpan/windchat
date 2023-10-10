import 'package:flutter/material.dart';
import 'package:windchat/main.dart';
import 'package:windchat/models/chat_user.dart';
import 'package:windchat/models/messages.dart';
import 'package:windchat/screens/chatscreen.dart';

import '../api/api.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;

  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  // To Store the last message - can be null
  Messages? _message;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: mq.width * .05, vertical: 5),
      elevation: 2,
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatScreen(
                        user: widget.user,
                      )));
        },
        child: StreamBuilder(
            stream: API.getLastMessages(widget.user),
            builder: (context, snapshot) {
              final data = snapshot.data?.docs;
              final lastmsg = data
                      ?.map((element) => Messages.fromJson(element.data()))
                      .toList() ??
                  [];
              if (lastmsg.isNotEmpty) {
                _message = lastmsg[0];
              }

              return ListTile(
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

                // User Name
                title: Text(widget.user.name),

                // About
                subtitle: Row(
                  children: [
                    if (_message == null)
                      Text(
                        widget.user.about,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                    else
                      Row(
                        children: [
                          if (_message!.read.isEmpty &&
                              _message!.fromID == API.user.uid)
                            const Icon(
                              Icons.done,
                              color: Colors.grey,
                            )
                          else if (_message!.read.isNotEmpty &&
                              _message!.fromID == API.user.uid)
                            const Icon(
                              Icons.done_all_sharp,
                              color: Colors.blue,
                            ),
                          Text(
                            _message!.msg,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      )
                  ],
                ),

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
              );
            }),
      ),
    );
  }
}
