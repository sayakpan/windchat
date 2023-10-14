import 'package:flutter/material.dart';
import 'package:windchat/api/api.dart';
import 'package:windchat/main.dart';
import 'package:windchat/screens/profilescreen.dart';
import 'package:windchat/widgets/chat_user_card.dart';
import 'package:windchat/widgets/drawar_side.dart';
import '../models/chat_user.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatUser> userlist = [];

  @override
  void initState() {
    super.initState();
    _initialiseOwnUser();
  }

  Future<void> _initialiseOwnUser() async {
    await API.getOwnUser();
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
          actions: [
            IconButton(
              icon: const Icon(Icons.person), // Profile Button
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ProfileScreen(user: API.ownuser)));
              },
            ),
          ],
        ),
        // drawer: SideDrawer(user: API.ownuser),
        drawer: FutureBuilder(
          future: API.getOwnUser(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(); // Loading indicator while waiting
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return SideDrawer(user: API.ownuser);
            }
          },
        ),
        body: StreamBuilder(
            stream: API.getAllUsers(),
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
