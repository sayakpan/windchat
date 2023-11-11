import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:windchat/api/api.dart';
import 'package:windchat/main.dart';
import 'package:windchat/models/chat_user.dart';
import 'package:windchat/widgets/add_chat_user_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, required ChatUser user});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<ChatUser> allUserlist = [];
  List<ChatUser> usersNotInContact = [];
  List<ChatUser> searchList = [];
  List<String> contactIdlist = [];
  bool isSearching = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onChanged: (value) {
            if (value.isNotEmpty) {
              isSearching = true;
            } else {
              isSearching = false;
            }
            searchList.clear();
            for (var user in usersNotInContact) {
              if (user.name.toLowerCase().contains(value.toLowerCase()) ||
                  user.email.toLowerCase().contains(value.toLowerCase())) {
                searchList.add(user);
                setState(() {
                  searchList;
                });
              }
            }
          },
          controller: _searchController,
          decoration: const InputDecoration(
              border: InputBorder.none, hintText: "Search name, email..."),
          autofocus: true,
          style: TextStyle(
            color: Theme.of(context).primaryColorDark,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // Hamburger menu icon
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          // Search Button
          IconButton(
            icon: const Icon(CupertinoIcons.clear_circled_solid),
            onPressed: () {
              setState(() {
                _searchController.clear();
              });
            },
          ),
        ],
      ),
      body: StreamBuilder(
          stream: API.getMyContactUsers(),
          builder: (context, snapshot) {
            final myContactUsersData = snapshot.data?.docs;
            contactIdlist =
                myContactUsersData?.map((element) => element.id).toList() ?? [];

            return StreamBuilder(
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
                      allUserlist = data
                              ?.map((element) =>
                                  ChatUser.fromJson(element.data()))
                              .toList() ??
                          [];

                      // Filter out users who are already in your contact list
                      usersNotInContact = allUserlist
                          .where((user) => !contactIdlist.contains(user.id))
                          .toList();
                      if (usersNotInContact.isNotEmpty) {
                        return ListView.builder(
                            itemCount: isSearching
                                ? searchList.length
                                : usersNotInContact.length,
                            padding: EdgeInsets.only(top: mq.height * 0.02),
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: ((context, index) {
                              return AddChatUserCard(
                                user: isSearching
                                    ? searchList[index]
                                    : usersNotInContact[index],
                              );
                            }));
                      } else {
                        return const Center(child: Text("No Users Found"));
                      }
                  }
                });
          }),
    );
  }
}
