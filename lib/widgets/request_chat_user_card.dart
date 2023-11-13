import 'package:flutter/material.dart';
import 'package:windchat/api/api.dart';
import 'package:windchat/api/notification_api.dart';
import 'package:windchat/main.dart';
import 'package:windchat/models/chat_user.dart';
import 'package:windchat/screens/userprofilescreen.dart';

class RequestChatUserCard extends StatefulWidget {
  final ChatUser user;

  const RequestChatUserCard({super.key, required this.user});

  @override
  State<RequestChatUserCard> createState() => _RequestChatUserCardState();
}

class _RequestChatUserCardState extends State<RequestChatUserCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
        color: const Color.fromARGB(255, 224, 255, 230),
        margin: EdgeInsets.symmetric(horizontal: mq.width * .05, vertical: 5),
        elevation: 2,
        child: ListTile(
            // Profile image
            leading: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserProfileScreen(
                              user: widget.user,
                            )));
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
            title: Text(
              widget.user.name,
              style: const TextStyle(color: Colors.black),
            ),

            // Subtitle
            subtitle: const Row(
              children: [
                Text("Wants to connect",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.black))
              ],
            ),
            trailing:
                // Accept and Reject buttons
                SizedBox(
              width: mq.width * .28,
              child: Stack(
                children: [
                  Positioned(
                    child: ElevatedButton(
                      onPressed: () {
                        API.acceptOrRejectNewContact(widget.user, "rejected");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: const CircleBorder(),
                        minimumSize: const Size(32, 32),
                        side: BorderSide(color: Colors.red.shade400, width: 1),
                      ),
                      child: const Icon(Icons.close, color: Colors.white),
                    ),
                  ),
                  Positioned(
                    left: mq.width * .13,
                    child: ElevatedButton(
                      onPressed: () {
                        API
                            .acceptOrRejectNewContact(widget.user, "approved")
                            .then((value) {
                          NotificationAPI.acceptedConnectionRequestNotification(
                              widget.user);
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        backgroundColor: Colors.green,
                        minimumSize: const Size(32, 32),
                      ),
                      child: const Icon(Icons.check, color: Colors.white),
                    ),
                  ),
                ],
              ),
            )));
  }
}
