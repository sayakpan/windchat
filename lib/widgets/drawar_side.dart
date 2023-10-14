import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:windchat/main.dart';
import 'package:windchat/models/chat_user.dart';
import 'package:windchat/screens/homescreen.dart';
import 'package:windchat/screens/profilescreen.dart';

import '../helper/dialogs.dart';
import '../screens/auth/loginscreen.dart';

class SideDrawer extends StatefulWidget {
  final ChatUser user;
  const SideDrawer({super.key, required this.user});

  @override
  State<SideDrawer> createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: mq.width * .8,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration:
                const BoxDecoration(color: Color.fromARGB(255, 90, 72, 255)),
            child: Row(children: [
              CircleAvatar(
                radius: 50.0,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color.fromARGB(255, 225, 225, 225),
                      width: 1.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 255, 255, 255)
                            .withOpacity(
                                0.2), // Adjust color and opacity as needed
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(
                            0, 3), // Adjust the position of the shadow
                      ),
                    ],
                  ),
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
              Padding(
                padding: EdgeInsets.only(
                    left: mq.width * 0.04, top: mq.width * 0.03),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(widget.user.name,
                        style:
                            const TextStyle(fontSize: 20, color: Colors.white)),
                    Padding(
                      padding: EdgeInsets.only(top: mq.width * 0.01),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 10,
                              minimumSize: const Size(30, 25),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              backgroundColor: Colors.white),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ProfileScreen(user: widget.user)));
                          },
                          child: const Text("See Profile",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400))),
                    )
                  ],
                ),
              )
            ]),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              // Handle the action when Settings is tapped
            },
          ),

          //Logout Button
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () async {
              Dialogs.showProgressBar(context);
              await FirebaseAuth.instance.signOut().then((value) async {
                await GoogleSignIn().signOut().then((value) {
                  // To pop the dialog
                  Navigator.pop(context);
                  // To pop the homepage
                  Navigator.pop(context);
                  // To go to the Login page
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                  log('Successfully Signed Out');
                });
              });
            },
          ),
        ],
      ),
    );
  }
}
