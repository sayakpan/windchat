import 'package:flutter/material.dart';
import 'package:windchat/api/api.dart';
import 'package:windchat/helper/dialogs.dart';
import 'package:windchat/helper/mydateutility.dart';
import 'package:windchat/main.dart';
import 'package:windchat/models/chat_user.dart';
import 'package:windchat/screens/homescreen.dart';

class ContactProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ContactProfileScreen({super.key, required this.user});

  @override
  State<ContactProfileScreen> createState() => _ContactProfileScreenState();
}

class _ContactProfileScreenState extends State<ContactProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // To Hide the Keyboard when click in the background
      onTap: () => FocusScope.of(context).unfocus(),

      // Scaffold From here
      child: Scaffold(
        appBar: AppBar(
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
              child: InkWell(
                onTap: () {
                  Dialogs.showImageDialog(context, widget.user.image);
                },
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
            ),

            // Name
            Positioned(
                top: mq.height * .3,
                child: Text(
                  widget.user.name,
                  style: TextStyle(
                      fontSize: 30, color: Theme.of(context).primaryColorDark),
                )),

            // Email
            Positioned(
                top: mq.height * .36,
                child: Text(
                  widget.user.email,
                  style: TextStyle(
                      fontSize: 20, color: Theme.of(context).primaryColorDark),
                )),

            //About Textform
            Positioned(
              top: mq.height * .42,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  children: [
                    Text(
                      "About: ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 19,
                          color: Theme.of(context).primaryColorDark),
                    ),
                    Text(widget.user.about,
                        style: TextStyle(
                            fontSize: 19,
                            color: Theme.of(context).primaryColorDark))
                  ],
                ),
              ),
            ),

            // Remove Contact Button
            Positioned(
                top: mq.height * .50,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    elevation: 3,
                    minimumSize: Size(
                      mq.width * .3,
                      mq.height * .05,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: const BorderSide(
                        color: Colors.red,
                        width: 1.0,
                      ),
                    ),
                  ),
                  icon: const Icon(Icons.remove_circle_outline,
                      color: Colors.red),
                  label: const Text(
                    "Remove Contact",
                    style: TextStyle(fontSize: 16, color: Colors.red),
                  ),
                  onPressed: () {
                    API.acceptOrRejectNewContact(widget.user, "rejected");
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ));
                  },
                )),

            // Date Joined
            Positioned(
              bottom: mq.height * .04,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  children: [
                    Text(
                      "Date Joined: ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Theme.of(context).primaryColorDark),
                    ),
                    Text(
                        MyDateUtility.getFormattedDateTime(
                            context: context, time: widget.user.createdAt),
                        style: TextStyle(
                            fontSize: 17,
                            color: Theme.of(context).primaryColorDark))
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
