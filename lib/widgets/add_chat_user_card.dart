import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:windchat/api/api.dart';
import 'package:windchat/helper/dialogs.dart';
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
            child: Stack(children: [
              CircleAvatar(
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
              if (widget.user.isOnline)
                Positioned(
                  top: 3,
                  right: 3,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                        border: Border.all(
                          strokeAlign: BorderSide.strokeAlignOutside,
                          color: const Color.fromARGB(255, 240, 240, 240),
                          width: 3.0,
                        ),
                        color: Colors.greenAccent.shade700,
                        borderRadius: BorderRadius.circular(50)),
                  ),
                )
            ]),
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
            width: mq.width * 0.17,
            child: FutureBuilder<String>(
              future: API.getConnectionStatus(widget.user),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child:
                          CircularProgressIndicator()); // Loading indicator while waiting for the result
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  String connectionStatus = snapshot.data ?? '';

                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        left: mq.width * 0.01,
                        child: ElevatedButton(
                          onPressed: () {
                            if (connectionStatus == "requested") {
                              API.removeContact(widget.user).then((value) {
                                Dialogs.showSnackBar(context, "Request unsent",
                                    Colors.blue.shade700);
                                setState(() {});
                              });
                            } else if (connectionStatus == "newrequest") {
                              Dialogs.showSnackBar(
                                  context,
                                  "${widget.user.name} Requested to connect.\nGo to homescreen to accept",
                                  Colors.amber.shade900);
                              setState(() {});
                            } else {
                              API
                                  .addNewContact(widget.user.email)
                                  .then((value) {
                                Dialogs.showSnackBar(context,
                                    "Connection request sent", Colors.green);
                                setState(() {});
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: connectionStatus == "requested"
                                ? Colors.red.shade700
                                : connectionStatus == "newrequest"
                                    ? Colors.yellow.shade700
                                    : Colors.blue.shade700,
                            shape: const CircleBorder(),
                            minimumSize: const Size(36, 36),
                            side: BorderSide(
                              color: connectionStatus == "requested"
                                  ? Colors.red.shade700
                                  : connectionStatus == "newrequest"
                                      ? Colors.yellow.shade700
                                      : Colors.blue.shade700,
                              width: 1,
                            ),
                          ),
                          child: connectionStatus == "requested"
                              ? const Icon(CupertinoIcons.person_badge_minus,
                                  color: Colors.white)
                              : connectionStatus == "newrequest"
                                  ? const Icon(
                                      CupertinoIcons
                                          .person_crop_circle_badge_exclam,
                                      color: Colors.white)
                                  : const Icon(Icons.person_add,
                                      color: Colors.white),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ));
  }
}
