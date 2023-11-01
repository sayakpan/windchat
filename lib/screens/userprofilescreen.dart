import 'package:flutter/material.dart';
import 'package:windchat/helper/mydateutility.dart';
import 'package:windchat/main.dart';
import 'package:windchat/models/chat_user.dart';

class UserProfileScreen extends StatefulWidget {
  final ChatUser user;
  const UserProfileScreen({super.key, required this.user});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // To Hide the Keyboard when click in the background
      onTap: () => FocusScope.of(context).unfocus(),

      // Scaffold From here
      child: Scaffold(
        appBar: AppBar(
          // toolbarHeight: mq.height * .09,
          // title: RichText(
          //   text: TextSpan(
          //     children: [
          //       TextSpan(
          //         text: widget.user.name,
          //         style: const TextStyle(
          //           fontSize: 25,
          //           color: Colors.black,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back), // Hamburger menu icon
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Stack(
          alignment: Alignment.center,
          children: [
            //Profile Picture and Edit Button
            Positioned(
              top: mq.height * .05,
              child: CircleAvatar(
                radius: 95.0,
                backgroundImage: NetworkImage(widget.user.image),
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color.fromARGB(255, 225, 225, 225),
                      width: 1.0,
                    ),
                  ),
                ),
              ),
            ),

// Name
            Positioned(
                top: mq.height * .3,
                child: Text(
                  widget.user.name,
                  style: const TextStyle(
                    fontSize: 30,
                  ),
                )),

            // Email
            Positioned(
                top: mq.height * .36,
                child: Text(
                  widget.user.email,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                )),

            //About Textform
            Positioned(
              top: mq.height * .42,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  children: [
                    const Text(
                      "About: ",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                    ),
                    Text(widget.user.about,
                        style: const TextStyle(
                          fontSize: 19,
                        ))
                  ],
                ),
              ),
            ),

            // Date Joined
            Positioned(
              bottom: mq.height * .04,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  children: [
                    const Text(
                      "Date Joined: ",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                    Text(
                        MyDateUtility.getFormattedDateTime(
                            context: context, time: widget.user.createdAt),
                        style: const TextStyle(
                          fontSize: 17,
                        ))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
