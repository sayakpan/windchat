import 'package:flutter/material.dart';
import 'package:windchat/api/encrypt_decrypt.dart';
import 'package:windchat/helper/mydateutility.dart';
import 'package:windchat/main.dart';
import 'package:windchat/models/chat_user.dart';
import 'package:windchat/models/messages.dart';
import 'package:windchat/screens/chatscreen.dart';
import 'package:windchat/widgets/profile_dialog.dart';

import '../api/api.dart';
import '../helper/unread_counter.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;

  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  // To Store the last message - can be null
  Messages? _message;
  late String content;

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
                if (_message!.type == 'text') {
                  content = EncryptDecrypt.decryptAES(_message!.msg);
                }
              }

              return ListTile(
                  // Profile image
                  leading: InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (_) => ProfileDialog(user: widget.user));
                    },
                    child: CircleAvatar(
                      radius: 25.0,
                      child: ClipOval(
                        child: Image.network(
                          widget.user.image,
                          fit: BoxFit.cover,
                          width: 100,
                          height: 100,
                        ),
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
                            _message!.type == "text"
                                ? Text(
                                    content.length > 17
                                        ? '${content.substring(0, 17)}...'
                                        : content,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  )
                                : const Row(
                                    children: [
                                      Icon(
                                        Icons.camera_alt,
                                        size: 17,
                                      ),
                                      Text(" Image")
                                    ],
                                  ),
                          ],
                        )
                    ],
                  ),
                  trailing:
                      // When No message is sent
                      _message == null
                          ? null

                          // For Unread Message
                          : _message!.read.isEmpty &&
                                  _message!.fromID != API.user.uid
                              ? Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                      color: Colors.greenAccent.shade400,
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Center(
                                      child: UnreadCounter(
                                    user: widget.user,
                                    numberstyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )),
                                )

                              //For sent messages
                              : Text(
                                  MyDateUtility.getFormattedTime(
                                      context: context, time: _message!.sent),
                                  style: const TextStyle(fontSize: 14),
                                ));
            }),
      ),
    );
  }
}
