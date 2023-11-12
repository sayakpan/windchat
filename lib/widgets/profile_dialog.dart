import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:windchat/main.dart';
import 'package:windchat/models/chat_user.dart';
import 'package:windchat/screens/contactprofilescreen.dart';

class ProfileDialog extends StatelessWidget {
  const ProfileDialog({super.key, required this.user});
  final ChatUser user;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: SizedBox(
          width: mq.width * .6,
          height: mq.height * .35,
          child: Stack(
            alignment: Alignment.center,
            children: [
              //user profile picture
              Positioned(
                top: mq.height * .075,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    width: mq.width * .46,
                    height: mq.height * .24,
                    fit: BoxFit.cover,
                    imageUrl: user.image,
                    placeholder: (context, url) {
                      return const Center(child: CircularProgressIndicator());
                    },
                    errorWidget: (context, url, error) =>
                        const CircleAvatar(child: Icon(CupertinoIcons.person)),
                  ),
                ),
              ),

              //user name
              Positioned(
                top: mq.height * .02,
                child: Text(user.name,
                    style: TextStyle(
                        color: Theme.of(context).primaryColorDark,
                        fontSize: 19,
                        fontWeight: FontWeight.w500)),
              ),

              //info button
              Positioned(
                  right: 8,
                  top: 6,
                  child: MaterialButton(
                    onPressed: () {
                      //for hiding image dialog
                      Navigator.pop(context);

                      //move to view profile screen
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  ContactProfileScreen(user: user)));
                    },
                    minWidth: 0,
                    padding: const EdgeInsets.all(0),
                    shape: const CircleBorder(),
                    child: const Icon(CupertinoIcons.info_circle_fill,
                        color: Color.fromARGB(255, 13, 140, 244), size: 30),
                  ))
            ],
          )),
    );
  }
}
