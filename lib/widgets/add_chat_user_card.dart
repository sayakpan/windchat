import 'package:flutter/material.dart';
import 'package:windchat/api/api.dart';
import 'package:windchat/main.dart';
import 'package:windchat/models/chat_user.dart';
import 'package:windchat/screens/userprofilescreen.dart';

class AddChatUserCard extends StatefulWidget {
  final ChatUser user;

  const AddChatUserCard({super.key, required this.user});

  @override
  State<AddChatUserCard> createState() => _AddChatUserCardState();
}

class _AddChatUserCardState extends State<AddChatUserCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.symmetric(horizontal: mq.width * .05, vertical: 5),
        elevation: 2,
        child: ListTile(
          textColor: Theme.of(context).primaryColorDark,
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
          ),

          // Subtitle
          subtitle: Row(
            children: [
              Text(
                widget.user.about.length > 25
                    ? '${widget.user.about.substring(0, 25)}...' // Display first 10 characters and add '...' if the string is longer
                    : widget.user.about,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
          trailing: SizedBox(
            width: mq.width * .17,
            child: Stack(alignment: Alignment.center, children: [
              Positioned(
                left: mq.width * .01,
                child: ElevatedButton(
                  onPressed: () {
                    API.addNewContact(widget.user.email);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    shape: const CircleBorder(),
                    minimumSize: const Size(36, 36),
                    side: BorderSide(color: Colors.blue.shade700, width: 1),
                  ),
                  child: const Icon(Icons.person_add, color: Colors.white),
                ),
              )
            ]),
          ),
        ));
  }
}
