import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:windchat/api/api.dart';
import 'package:windchat/main.dart';
import 'package:windchat/screens/profilescreen.dart';
import 'package:windchat/screens/splashscreen.dart';
import 'package:windchat/widgets/chat_user_card.dart';
import '../models/chat_user.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Signout Function
  signout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const SplashScreen()));
  }

  List<ChatUser> userlist = [];

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
          actions: [
            IconButton(
              icon: const Icon(Icons.person), // Profile Button
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfileScreen()));
              },
            ),
            IconButton(
              icon: const Icon(Icons.exit_to_app_rounded), // SIGN OUT
              onPressed: () {
                signout(context);
              },
            ),
          ],
        ),
        body: StreamBuilder(
            stream: API.firestore.collection("users").snapshots(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                case ConnectionState.active:
                case ConnectionState.done:
                  final data = snapshot.data?.docs;
                  userlist = data
                          ?.map((element) => ChatUser.fromJson(element.data()))
                          .toList() ??
                      [];
                  if (userlist.isNotEmpty) {
                    return ListView.builder(
                        itemCount: userlist.length,
                        padding: EdgeInsets.only(top: mq.height * 0.02),
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: ((context, index) {
                          return ChatUserCard(
                            user: userlist[index],
                          );
                        }));
                  } else {
                    return const Center(child: Text("No Users Found"));
                  }
              }
            }));
  }
}
