import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:windchat/main.dart';
import 'package:windchat/widgets/chat_user_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Signout Function
  _signout() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // toolbarHeight: mq.height * .09,
          title: RichText(
            text: TextSpan(
              children: [
                const TextSpan(
                  text: 'Wind',
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.black,
                  ),
                ),
                TextSpan(
                  text: 'Chat',
                  style: TextStyle(
                    fontSize: 25,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.menu), // Hamburger menu icon
            onPressed: () {
              // Add the action you want to perform when the icon is pressed
            },
          ),
        ),
        body: ListView.builder(
            itemCount: 5,
            padding: EdgeInsets.only(top: mq.height * 0.02),
            physics: const BouncingScrollPhysics(),
            itemBuilder: ((context, index) {
              return const ChatUserCard();
            })));
  }
}
