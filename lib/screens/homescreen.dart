import 'package:flutter/material.dart';
import 'package:windchat/api/api.dart';
import 'package:windchat/helper/dialogs.dart';
import 'package:windchat/main.dart';
import 'package:windchat/screens/profilescreen.dart';
import 'package:windchat/widgets/chat_user_card.dart';
import 'package:windchat/widgets/drawar_side.dart';
import 'package:windchat/widgets/request_chat_user_card.dart';
import '../models/chat_user.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatUser> userlist = [];
  List<String> idlist = [];
  List<String> newrequestList = [];

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
                      builder: (context) => ProfileScreen(user: API.ownuser)));
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
        // Get the id of contacts only
        stream: API.getMyContactUsers(),
        builder: (context, snapshot) {
          final myContactUsersData = snapshot.data?.docs;
          idlist =
              myContactUsersData?.map((element) => element.id).toList() ?? [];

          // Getting the list of id of the new incoming requests - to be used later
          newrequestList = myContactUsersData
                  ?.where((doc) => doc.data()['status'] == 'newrequest')
                  .map((element) => element.id)
                  .toList() ??
              [];

          if (idlist.isNotEmpty) {
            return StreamBuilder(
                // Get the User of the contacts, provided by the upper stream
                stream: API.getAllUsersByIdList(idlist),
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
                              ?.map((element) =>
                                  ChatUser.fromJson(element.data()))
                              .toList() ??
                          [];
                      if (userlist.isNotEmpty) {
                        return ListView.builder(
                            itemCount: userlist.length,
                            padding: EdgeInsets.only(top: mq.height * 0.02),
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: ((context, index) {
                              if (newrequestList.contains(userlist[index].id))
                              // For users with a new request
                              {
                                return RequestChatUserCard(
                                  user: userlist[index],
                                );
                              }
                              // Existing chats
                              else {
                                return ChatUserCard(
                                  user: userlist[index],
                                );
                              }
                            }));
                      } else {
                        return const Center(child: Text("No Users Found"));
                      }
                  }
                });
          } else {
            return const Center(
                child: Text(
              "No chat buddies in sight?\nTime to add some friends here. 👋",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 17),
            ));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addContactDialog();
        },
        backgroundColor: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        foregroundColor: Colors.white,
        child: const Icon(Icons.person_add),
      ),
    );
  }

// to add contact
  void addContactDialog() {
    String email = '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding:
            const EdgeInsets.only(left: 24, right: 24, top: 20, bottom: 5),
        title: Row(
          children: [
            Icon(
              Icons.person_add,
              color: Theme.of(context).primaryColor,
              size: 30,
            ),
            const Text(
              "   Add New Contact",
              style: TextStyle(
                fontSize: 20,
              ),
            )
          ],
        ),
        content: TextFormField(
          maxLines: null,
          onChanged: (value) => email = value,
          decoration: InputDecoration(
              hintText: "Enter Email",
              prefixIcon: Icon(
                Icons.email,
                color: Theme.of(context).primaryColor,
              ),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 114, 114, 114)),
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                    if (email.isNotEmpty) {
                      API.addNewContact(email).then((value) {
                        if (value) {
                          Dialogs.showSnackBar(context,
                              "Contact Added Succesfully", Colors.green);
                        } else {
                          Dialogs.showSnackBar(
                              context,
                              "Contact not registered.\nAsk your friend to install WindChat.",
                              Colors.red);
                        }
                      });
                    } else {
                      Navigator.pop(context);
                      Dialogs.showSnackBar(
                          context, "Email is required", Colors.red);
                    }
                  },
                  child: Text(
                    "Add",
                    style: TextStyle(
                        fontSize: 18, color: Theme.of(context).primaryColor),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
